# Database Generation Summary

## What Was Created

I've created a complete solution for generating a relational database schema from the GCWG-RDA-maDMP JSON Schema. This includes:

### 1. Main Script: `generate_database_schema.py`

A Python script that automatically converts the JSON schema into a normalized relational database schema.

**Key Features:**
- Parses the complex nested JSON schema structure
- Creates normalized tables for all objects and arrays
- Establishes foreign key relationships automatically
- Generates proper indexes for performance
- Supports multiple database types (PostgreSQL, MySQL, SQLite)
- Can generate Entity Relationship Diagrams (ERD) in Mermaid format
- Includes comprehensive documentation in SQL comments

**Generated Output:**
- **94 tables** representing the complete maDMP structure
- **582 columns** across all tables
- **93 foreign key relationships** maintaining referential integrity
- Proper indexing on all foreign key columns

### 2. Generated SQL Schema: `madmp_database_schema.sql`

The actual SQL DDL (Data Definition Language) statements to create the database.

**Contents:**
- CREATE TABLE statements for all 94 tables
- ALTER TABLE statements for foreign key constraints
- CREATE INDEX statements for all foreign keys
- COMMENT statements for table documentation (PostgreSQL)

### 3. ERD Diagrams

**`madmp_database_schema_erd.mmd`** - Mermaid format
- Shows all table relationships with cardinality
- Displays field names only (no data types for clarity)
- Can be viewed in:
  - Mermaid Live Editor (https://mermaid.live/)
  - VS Code with Mermaid extension
  - GitHub (automatically renders Mermaid diagrams)

**`madmp_database_schema_erd.graphml`** - GraphML format for yEd Graph Editor
- Entity-Relationship style diagram
- Shows all tables with their field names
- Directed edges for foreign key relationships
- Can be opened and edited in:
  - yEd Graph Editor (https://www.yworks.com/products/yed) - **Recommended**
  - Gephi (https://gephi.org/)
  - Cytoscape (https://cytoscape.org/)
- Supports automatic layout algorithms
- Can export to PNG, PDF, SVG, and other formats

### 4. Data Population Script: `populate_database_from_json.py`

A Python script (template/example) that shows how to populate the database from a JSON instance.

**Features:**
- Demonstrates the pattern for inserting data
- Handles nested objects and arrays
- Maintains referential integrity
- Uses parameterized queries for security
- Includes transaction management

**Note:** This is a partial implementation showing the pattern. You would need to complete all the `process_*` methods for a full implementation.

### 5. Documentation: `README_DATABASE_GENERATION.md`

Comprehensive documentation covering:
- How to use the generation script
- Database schema structure
- Design decisions
- Usage examples
- Query examples
- Limitations and considerations

## How the Schema Works

### Table Naming Convention

Tables are named based on their path in the JSON schema:
- `dmp` → Root table
- `dmp/general_info` → `dmp_general_info`
- `dmp/dataset/distribution` → `dmp_dataset_distribution`

### Handling Different JSON Schema Types

#### 1. Simple Properties (strings, numbers, booleans)
Become columns in the parent table:
```sql
CREATE TABLE dmp_general_info (
    id SERIAL PRIMARY KEY,
    dmp_id INTEGER,
    title TEXT,
    description TEXT,
    created TIMESTAMP,
    ...
);
```

#### 2. Objects
Become separate tables with a foreign key to the parent:
```sql
CREATE TABLE dmp_contact (
    id SERIAL PRIMARY KEY,
    dmp_id INTEGER,  -- Foreign key to dmp
    name TEXT,
    mbox VARCHAR(2048),
    ...
);
```

#### 3. Arrays of Objects
Become separate tables with foreign key and array_index:
```sql
CREATE TABLE dmp_contributor (
    id SERIAL PRIMARY KEY,
    dmp_id INTEGER NOT NULL,  -- Foreign key to dmp
    array_index INTEGER,       -- Position in array
    name TEXT,
    mbox VARCHAR(2048),
    ...
);
```

#### 4. Arrays of Primitives
Become junction tables with a value column:
```sql
CREATE TABLE dmp_contributor_role (
    id SERIAL PRIMARY KEY,
    dmp_contributor_id INTEGER NOT NULL,  -- Foreign key to parent
    array_index INTEGER,                   -- Position in array
    value TEXT                             -- The actual role value
);
```

### Foreign Key Relationships

All relationships use CASCADE delete to maintain referential integrity:
```sql
ALTER TABLE dmp_contributor 
ADD CONSTRAINT fk_dmp_contributor_dmp_id 
FOREIGN KEY (dmp_id) 
REFERENCES dmp(id) 
ON DELETE CASCADE;
```

This means if you delete a DMP, all its contributors, datasets, etc. are automatically deleted.

## Example Database Structure

Here's a simplified view of the main tables and their relationships:

```
dmp (root)
├── dmp_general_info
│   ├── dmp_general_info_dmp_id
│   └── dmp_general_info_linked_dmp
│       └── dmp_general_info_linked_dmp_linked_dmp_id
├── dmp_contact
│   ├── dmp_contact_contact_id
│   ├── dmp_contact_affiliation
│   ├── dmp_contact_telephone
│   └── dmp_contact_fax
├── dmp_contributor (array)
│   ├── dmp_contributor_role (array of strings)
│   ├── dmp_contributor_contributor_id
│   ├── dmp_contributor_affiliation (array)
│   ├── dmp_contributor_telephone (array)
│   └── dmp_contributor_fax (array)
├── dmp_approval
├── dmp_project (array)
│   ├── dmp_project_funding (array)
│   │   ├── dmp_project_funding_source (array)
│   │   ├── dmp_project_funding_funder_id
│   │   └── dmp_project_funding_grant_id
│   └── dmp_project_partner_organization (array)
├── dmp_cost (array)
│   └── dmp_cost_cost_documentation (array)
├── dmp_indigenous_considerations
│   ├── dmp_indigenous_considerations_community_approval (array)
│   ├── dmp_indigenous_considerations_group_identification (array)
│   ├── dmp_indigenous_considerations_research_method (array)
│   ├── dmp_indigenous_considerations_indian_band_name (array)
│   └── dmp_indigenous_considerations_indian_band_number (array)
└── dmp_dataset (array)
    ├── dmp_dataset_dataset_id
    ├── dmp_dataset_subject (array)
    ├── dmp_dataset_keyword (array)
    ├── dmp_dataset_dataset_documentation (array)
    ├── dmp_dataset_security_and_privacy (array)
    ├── dmp_dataset_technical_resource (array)
    │   ├── dmp_dataset_technical_resource_data_management_system
    │   ├── dmp_dataset_technical_resource_hardware_requirements
    │   └── dmp_dataset_technical_resource_software (array)
    ├── dmp_dataset_metadata (array)
    ├── dmp_dataset_creator (array)
    ├── dmp_dataset_distribution (array)
    │   ├── dmp_dataset_distribution_distribution_id
    │   ├── dmp_dataset_distribution_format (array)
    │   ├── dmp_dataset_distribution_host
    │   ├── dmp_dataset_distribution_online_service (array)
    │   ├── dmp_dataset_distribution_physical_data_asset (array)
    │   └── dmp_dataset_distribution_data_integrity
    └── dmp_dataset_disposition_planning
        ├── dmp_dataset_disposition_planning_retention_specification (array)
        └── dmp_dataset_disposition_planning_disposition_impediment (array)
```

## Quick Start Guide

### 1. Generate the Database Schema

```bash
cd JSON
python generate_database_schema.py --summary --erd
```

This creates:
- `madmp_database_schema.sql` - The SQL schema
- `madmp_database_schema_erd.mmd` - The ERD diagram

### 2. Create the Database

**PostgreSQL:**
```bash
createdb madmp_database
psql madmp_database < madmp_database_schema.sql
```

**MySQL:**
```bash
mysql -u root -p -e "CREATE DATABASE madmp_database;"
python generate_database_schema.py --database mysql --output madmp_mysql_schema.sql
mysql -u root -p madmp_database < madmp_mysql_schema.sql
```

**SQLite:**
```bash
python generate_database_schema.py --database sqlite --output madmp_sqlite_schema.sql
sqlite3 madmp_database.db < madmp_sqlite_schema.sql
```

### 3. Populate with Data (Optional)

If you have a JSON instance of a maDMP:

```bash
# Install required package
pip install psycopg2-binary

# Populate database (after completing the populate script)
python populate_database_from_json.py --json example_madmp.json --db postgresql://localhost/madmp_database
```

### 4. Query the Database

```sql
-- Get all DMPs with their titles
SELECT g.title, g.description, g.created
FROM dmp d
JOIN dmp_general_info g ON d.id = g.dmp_id;

-- Get all datasets for a specific DMP
SELECT ds.title, ds.description, ds.type
FROM dmp_dataset ds
WHERE ds.dmp_id = 1;

-- Get contributors and their roles
SELECT c.name, r.value as role
FROM dmp_contributor c
JOIN dmp_contributor_role r ON c.id = r.dmp_contributor_id
WHERE c.dmp_id = 1;
```

## Benefits of This Approach

1. **Normalization**: Data is properly normalized, reducing redundancy
2. **Referential Integrity**: Foreign keys ensure data consistency
3. **Query Performance**: Indexes on foreign keys enable fast queries
4. **Scalability**: Can handle large numbers of DMPs efficiently
5. **Standard SQL**: Works with any SQL database
6. **Type Safety**: SQL types enforce data validation
7. **Transactions**: ACID properties ensure data integrity
8. **Backup/Recovery**: Standard database backup tools work
9. **Concurrent Access**: Multiple users can access simultaneously
10. **Reporting**: Easy to create reports and analytics

## Use Cases

This database schema is useful for:

1. **DMP Management Systems**: Store and manage multiple DMPs
2. **Institutional Repositories**: Track DMPs for research projects
3. **Compliance Tracking**: Monitor DMP requirements and approvals
4. **Analytics**: Analyze DMP trends, costs, datasets, etc.
5. **Integration**: Connect DMPs with other research systems
6. **Validation**: Ensure DMPs meet institutional requirements
7. **Versioning**: Track changes to DMPs over time
8. **Reporting**: Generate reports on data management practices

## Next Steps

To fully utilize this database schema:

1. **Complete the Population Script**: Implement all `process_*` methods in `populate_database_from_json.py`
2. **Add Validation**: Implement database triggers or application logic for conditional requirements
3. **Create Views**: Build views for common query patterns
4. **Add Indexes**: Create additional indexes for frequently queried columns
5. **Implement ORM**: Create SQLAlchemy or Django models
6. **Build API**: Create a REST or GraphQL API on top of the database
7. **Create UI**: Build a web interface for managing DMPs
8. **Add Versioning**: Implement temporal tables for tracking changes
9. **Setup Backups**: Configure regular database backups
10. **Performance Tuning**: Optimize queries and indexes based on usage patterns

## Files Created

| File | Purpose | Lines |
|------|---------|-------|
| `generate_database_schema.py` | Main schema generation script | ~488 |
| `madmp_database_schema.sql` | Generated SQL DDL | ~1,385 |
| `madmp_database_schema_erd.mmd` | ERD diagram | ~300 |
| `populate_database_from_json.py` | Data population template | ~300 |
| `README_DATABASE_GENERATION.md` | Comprehensive documentation | ~250 |
| `DATABASE_GENERATION_SUMMARY.md` | This summary | ~300 |

**Total:** ~3,000 lines of code and documentation

## Support and Customization

The `generate_database_schema.py` script can be customized by:

1. Modifying the `get_sql_type()` method to change type mappings
2. Adjusting the `sanitize_name()` method for different naming conventions
3. Changing the foreign key behavior (CASCADE, SET NULL, etc.)
4. Adding custom indexes or constraints
5. Generating additional database objects (views, functions, triggers)

For questions or issues, refer to the detailed documentation in `README_DATABASE_GENERATION.md`.

