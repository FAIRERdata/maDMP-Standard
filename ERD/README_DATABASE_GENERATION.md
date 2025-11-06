# Database Schema Generation from maDMP JSON Schema

## Overview

This directory contains a Python script (`generate_database_schema.py`) that automatically generates a relational database schema from the GCWG-RDA-maDMP JSON Schema. The script parses the complex nested JSON schema and creates normalized database tables with appropriate foreign key relationships.

## Features

- **Automatic Table Generation**: Creates tables for all objects and arrays in the JSON schema
- **Foreign Key Relationships**: Automatically establishes parent-child relationships
- **Array Handling**: Properly handles both arrays of objects and arrays of primitives
- **Type Mapping**: Maps JSON schema types to appropriate SQL data types
- **Multiple Database Support**: Supports PostgreSQL, MySQL, and SQLite
- **ERD Generation**: Can generate Mermaid Entity Relationship Diagrams
- **Comprehensive Documentation**: Includes comments and descriptions from the JSON schema

## Generated Schema Statistics

From the GCWG-RDA-maDMP JSON Schema, the script generates:

- **94 tables** representing the complete maDMP structure
- **582 columns** across all tables
- **93 foreign key relationships** maintaining referential integrity
- Proper indexing on all foreign key columns for performance

## Usage

### Basic Usage

Generate a PostgreSQL database schema:

```bash
python generate_database_schema.py
```

This will create `madmp_database_schema.sql` in the current directory.

### Command Line Options

```bash
python generate_database_schema.py [OPTIONS]
```

**Options:**

- `--input <file>`: Path to the JSON schema file (default: `GCWG-RDA-maDMP-schema.json`)
- `--output <file>`: Path to the output SQL file (default: `madmp_database_schema.sql`)
- `--database <type>`: Target database type: `postgresql`, `mysql`, or `sqlite` (default: `postgresql`)
- `--summary`: Print a summary of the generated schema
- `--erd`: Generate a Mermaid ERD diagram file

### Examples

**Generate schema with summary:**
```bash
python generate_database_schema.py --summary
```

**Generate schema for MySQL:**
```bash
python generate_database_schema.py --database mysql --output madmp_mysql_schema.sql
```

**Generate schema with ERD diagrams (Mermaid and GraphML):**
```bash
python generate_database_schema.py --erd
```

This will generate:
- `madmp_database_schema_erd.mmd` - Mermaid format (for GitHub, VS Code, Mermaid Live Editor)
- `madmp_database_schema_erd.graphml` - GraphML format (for yEd Graph Editor)

**Custom input and output:**
```bash
python generate_database_schema.py --input custom_schema.json --output custom_db.sql
```

## Database Schema Structure

### Root Table

- **dmp**: The root table representing a Data Management Plan

### Main Entity Tables

The schema includes tables for all major maDMP entities:

- **dmp_general_info**: General DMP information (title, description, dates, etc.)
- **dmp_contact**: Contact information for the DMP
- **dmp_contributor**: Contributors to the DMP
- **dmp_dataset**: Datasets described in the DMP
- **dmp_project**: Projects related to the DMP
- **dmp_cost**: Cost information
- **dmp_indigenous_considerations**: Indigenous data considerations
- **dmp_approval**: DMP approval information

### Nested Structures

Complex nested structures are represented as separate tables with foreign keys:

- **dmp_dataset_distribution**: Data distributions (files, formats, access methods)
- **dmp_dataset_metadata**: Metadata standards used
- **dmp_dataset_technical_resource**: Technical resources (software, hardware, systems)
- **dmp_contributor_affiliation**: Contributor organizational affiliations
- **dmp_project_funding**: Project funding information

### Array Handling

Arrays in the JSON schema are handled in two ways:

1. **Arrays of Objects**: Create a separate table with a foreign key to the parent and an `array_index` column
2. **Arrays of Primitives**: Create a junction table with `value` and `array_index` columns

Example:
- `dmp_contributor` (array of objects) → separate table with `dmp_id` foreign key
- `dmp_contributor_role` (array of strings) → junction table with `value` column

## Key Design Decisions

### Primary Keys

All tables use auto-incrementing integer primary keys (`SERIAL` in PostgreSQL):
```sql
id SERIAL PRIMARY KEY
```

### Foreign Keys

Foreign key relationships use `ON DELETE CASCADE` to maintain referential integrity:
```sql
ALTER TABLE child_table 
ADD CONSTRAINT fk_child_parent 
FOREIGN KEY (parent_id) 
REFERENCES parent_table(id) 
ON DELETE CASCADE;
```

### Indexes

All foreign key columns are automatically indexed for query performance:
```sql
CREATE INDEX idx_child_table_parent_id ON child_table(parent_id);
```

### Data Types

JSON schema types are mapped to SQL types as follows:

| JSON Type | SQL Type (PostgreSQL) |
|-----------|----------------------|
| string | TEXT |
| number | NUMERIC |
| integer | INTEGER |
| boolean | BOOLEAN |
| string (format: date) | DATE |
| string (format: date-time) | TIMESTAMP |
| string (format: uri/url/email) | VARCHAR(2048) |
| enum | VARCHAR(255) |

## Using the Generated Schema

### Creating the Database (PostgreSQL)

```bash
# Create a new database
createdb madmp_database

# Run the schema
psql madmp_database < madmp_database_schema.sql
```

### Creating the Database (MySQL)

```bash
# Create a new database
mysql -u root -p -e "CREATE DATABASE madmp_database;"

# Run the schema
mysql -u root -p madmp_database < madmp_mysql_schema.sql
```

### Creating the Database (SQLite)

```bash
# Create and populate the database
sqlite3 madmp_database.db < madmp_sqlite_schema.sql
```

## Viewing the ERD

### Mermaid ERD (`.mmd` file)

The Mermaid ERD file can be viewed using:

1. **Mermaid Live Editor**: https://mermaid.live/
2. **VS Code**: Install the "Markdown Preview Mermaid Support" extension
3. **GitHub**: GitHub automatically renders Mermaid diagrams in Markdown files

The Mermaid ERD shows:
- All table relationships with cardinality (one-to-many)
- Field names only (without data types for clarity)
- All 94 tables and 93 foreign key relationships

### GraphML ERD (`.graphml` file)

The GraphML ERD file can be opened and edited with:

1. **yEd Graph Editor**: https://www.yworks.com/products/yed (Free download)
   - Open the `.graphml` file directly in yEd
   - Use automatic layout algorithms (Layout → Hierarchical, Organic, etc.)
   - Customize colors, shapes, and positions
   - Export to PNG, PDF, SVG, or other formats

2. **Gephi**: https://gephi.org/ (Open source graph visualization)

3. **Cytoscape**: https://cytoscape.org/ (Network visualization)

The GraphML ERD includes:
- Entity-Relationship style nodes with table names and field names
- Directed edges showing foreign key relationships
- Initial grid layout (can be rearranged in yEd)
- All field names listed within each table node

## Example: Querying the Database

Once the database is created and populated with data, you can query it:

```sql
-- Get all datasets for a specific DMP
SELECT d.title, d.description, d.type
FROM dmp_dataset d
WHERE d.dmp_id = 1;

-- Get all contributors and their roles for a DMP
SELECT c.name, r.value as role
FROM dmp_contributor c
JOIN dmp_contributor_role r ON c.id = r.dmp_contributor_id
WHERE c.dmp_id = 1;

-- Get all distributions for a dataset with their formats
SELECT ds.title as dataset_title, 
       dist.title as distribution_title,
       f.value as format
FROM dmp_dataset ds
JOIN dmp_dataset_distribution dist ON ds.id = dist.dmp_dataset_id
JOIN dmp_dataset_distribution_format f ON dist.id = f.dmp_dataset_distribution_id
WHERE ds.dmp_id = 1;
```

## Limitations and Considerations

1. **Conditional Requirements**: The JSON schema's conditional logic (`if/then`, `requiredWhen`, etc.) is not enforced at the database level. Application logic or database triggers would be needed to enforce these rules.

2. **Enum Values**: Enum constraints from the JSON schema are not enforced as database CHECK constraints. Consider adding these manually if needed.

3. **Table Name Length**: Table names are limited to 63 characters (PostgreSQL limit) and are automatically truncated if longer.

4. **Denormalization**: For performance-critical applications, you may want to denormalize some frequently-accessed nested structures.

5. **JSON Columns**: Some deeply nested or variable structures might be better stored as JSON/JSONB columns rather than fully normalized tables.

## Future Enhancements

Potential improvements to the script:

- Generate ORM models (SQLAlchemy, Django ORM, etc.)
- Add CHECK constraints for enum values
- Generate database triggers for conditional requirements
- Create views for common query patterns
- Generate sample data insertion scripts
- Add support for database migrations (Alembic, Flyway, etc.)
- Generate GraphQL schema from the database structure

## Support

For questions or issues related to the database schema generation:

1. Check the JSON schema documentation
2. Review the generated SQL file for specific table structures
3. Examine the script's source code for customization options

## License

This script is part of the maDMP-Standard project and follows the same license terms.

