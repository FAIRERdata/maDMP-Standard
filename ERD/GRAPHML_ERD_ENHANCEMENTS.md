# GraphML ERD Enhancements

## Summary

Enhanced the GraphML ERD generation in `generate_database_schema.py` to provide better visualization in yEd Graph Editor with:

1. **Two-label system for tables**: Field names inside the box, table name below the box
2. **Cardinality labels on relationship arrows**: Shows the multiplicity of relationships

## Changes Made

### 1. Two-Label System for Tables

**Before:**
- Single label with table name and all fields combined
- Table name was at the top of the field list inside the box

**After:**
- **First label (inside box)**: Contains only field names, left-aligned, font size 11
- **Second label (below box)**: Contains table name, centered, bold, font size 13

**Benefits:**
- Cleaner visual separation between table name and fields
- Table names are more prominent and easier to read
- Better use of space in the diagram
- Follows standard ERD conventions

### 2. Cardinality Labels on Edges

**Cardinality Notation:**
- **Parent side (source)**: Always "1" (one parent record)
- **Child side (target)**: 
  - `0..*` - Array relationship (zero or more child records)
  - `0..1` - Optional single object (zero or one child record)
  - `1` - Required single object (exactly one child record)

**How Cardinality is Determined:**

The code analyzes the child table structure to determine cardinality:

```python
# Check if this is an array relationship (has array_index column)
is_array = 'array_index' in child_columns

# Check if foreign key is NOT NULL
is_required = fk_column_def and 'NOT NULL' in fk_column_def.get('type', '')

# Determine cardinality
if is_array:
    child_cardinality = "0..*"  # Array can have zero or more items
elif is_required:
    child_cardinality = "1"     # Required single object
else:
    child_cardinality = "0..1"  # Optional single object
```

**Label Positioning:**
- **Source label (parent)**: Positioned at the source head of the arrow (`modelPosition="shead"`)
- **Target label (child)**: Positioned at the target head of the arrow (`modelPosition="thead"`)

## Examples

### Example 1: Array Relationship (0..*)

**Relationship:** `dmp` → `dmp_contributor`

```
dmp (1) ────────→ (0..*) dmp_contributor
```

- One DMP can have zero or more contributors
- The `dmp_contributor` table has `array_index` column
- Foreign key `dmp_id` is NOT NULL

### Example 2: Optional Object (0..1)

**Relationship:** `dmp` → `dmp_contact`

```
dmp (1) ────────→ (0..1) dmp_contact
```

- One DMP can have zero or one contact
- The `dmp_contact` table does NOT have `array_index` column
- Foreign key `dmp_id` is nullable

### Example 3: Required Object (1)

**Relationship:** `dmp_contributor` → `dmp_contributor_affiliation` (if it were required)

```
parent (1) ────────→ (1) child
```

- One parent must have exactly one child
- The child table does NOT have `array_index` column
- Foreign key is NOT NULL

## Visual Improvements

### Node (Table) Appearance

**Before:**
```
┌─────────────────────┐
│ dmp_contact         │
│ id                  │
│ dmp_id              │
│ name                │
│ mbox                │
│ ...                 │
└─────────────────────┘
```

**After:**
```
┌─────────────────────┐
│ id                  │
│ dmp_id              │
│ name                │
│ mbox                │
│ telephone           │
│ fax                 │
│ ...                 │
└─────────────────────┘
    dmp_contact
```

### Edge (Relationship) Appearance

**Before:**
```
dmp ──────────→ dmp_contact
```

**After:**
```
dmp  1 ──────→ 0..1  dmp_contact
```

## Code Changes

### File: `JSON/generate_database_schema.py`

**Lines 363-451**: Modified `generate_erd_graphml()` method - Node generation
- Increased `y_spacing` from 200 to 250 to accommodate table name label below boxes
- Split label into two separate `<y:NodeLabel>` elements:
  - First label: Field names only, `modelPosition="c"` (center of node)
  - Second label: Table name, `modelPosition` with custom `SmartNodeLabelModel` positioned below the node

**Lines 453-511**: Modified `generate_erd_graphml()` method - Edge generation
- Added logic to determine cardinality based on table structure
- Added two `<y:EdgeLabel>` elements per edge:
  - Source label: Parent cardinality (always "1")
  - Target label: Child cardinality ("0..*", "0..1", or "1")

## Usage in yEd Graph Editor

1. **Open the GraphML file** in yEd Graph Editor
2. **Apply automatic layout**: 
   - Go to **Layout → Hierarchical** (recommended for database schemas)
   - Or try **Layout → Organic** for a more natural layout
3. **Customize appearance**:
   - Table names are now below boxes and can be easily repositioned
   - Cardinality labels are on the arrows and can be moved if needed
   - All labels are editable and can be customized
4. **Export**:
   - **File → Export** to PNG, PDF, SVG, or other formats
   - High-quality output suitable for documentation

## Benefits

### For Database Design
- **Clear relationship understanding**: Cardinality shows exactly how tables relate
- **Better documentation**: Visual representation matches standard ERD notation
- **Easier validation**: Can quickly verify if relationships are correct

### For yEd Editing
- **More flexible layout**: Table names below boxes don't interfere with field lists
- **Better readability**: Bold table names stand out from field names
- **Professional appearance**: Follows ERD best practices

### For Collaboration
- **Standard notation**: Team members familiar with ERDs will understand immediately
- **Self-documenting**: Cardinality labels reduce need for additional documentation
- **Export-ready**: Diagrams are publication-quality

## Technical Details

### GraphML Label Model

The table name label uses yEd's `SmartNodeLabelModel` with custom positioning:

```xml
<y:NodeLabel alignment="center" autoSizePolicy="content" 
             fontFamily="Dialog" fontSize="13" fontStyle="bold" 
             modelName="custom" textColor="#000000" visible="true">
    table_name
    <y:LabelModel>
        <y:SmartNodeLabelModel distance="4.0"/>
    </y:LabelModel>
    <y:ModelParameter>
        <y:SmartNodeLabelModelParameter 
            labelRatioX="0.0" labelRatioY="0.5" 
            nodeRatioX="0.0" nodeRatioY="1.0" 
            offsetX="0.0" offsetY="4.0" 
            upX="0.0" upY="-1.0"/>
    </y:ModelParameter>
</y:NodeLabel>
```

**Parameters explained:**
- `nodeRatioY="1.0"`: Position at bottom of node (1.0 = 100% down)
- `offsetY="4.0"`: 4 pixels below the node
- `labelRatioY="0.5"`: Center of label aligns with anchor point
- `upY="-1.0"`: Label orientation (upright)

### Edge Label Positioning

Cardinality labels use the `six_pos` model with specific positions:

```xml
<!-- Parent cardinality (source) -->
<y:EdgeLabel modelName="six_pos" modelPosition="shead" ...>1</y:EdgeLabel>

<!-- Child cardinality (target) -->
<y:EdgeLabel modelName="six_pos" modelPosition="thead" ...>0..*</y:EdgeLabel>
```

**Positions:**
- `shead`: Source head (near the parent table)
- `thead`: Target head (near the child table)

## Regenerating the ERD

To regenerate the GraphML ERD with these enhancements:

```bash
cd JSON
python generate_database_schema.py --input GCWG-RDA-maDMP-schema.json --output madmp_database_schema.sql --erd
```

This will create:
- `madmp_database_schema.sql` - PostgreSQL database schema
- `madmp_database_schema_erd.mmd` - Mermaid ERD diagram
- `madmp_database_schema_erd.graphml` - GraphML ERD diagram (with enhancements)

## Future Enhancements

Potential future improvements:

1. **Color coding by cardinality**: Different colors for 1:1, 1:N, and N:M relationships
2. **Primary key indicators**: Bold or underline primary key fields
3. **Foreign key highlighting**: Different color for foreign key fields
4. **Data type display**: Option to show data types alongside field names
5. **Relationship names**: Add labels to edges showing the relationship name
6. **Grouping**: Group related tables visually (e.g., all dataset-related tables)

## Compatibility

- **yEd Graph Editor**: Version 3.x and later
- **GraphML Format**: Version 1.1
- **yFiles**: Compatible with yFiles-based tools

## Files Modified

- `JSON/generate_database_schema.py` - Enhanced GraphML generation
- `JSON/madmp_database_schema_erd.graphml` - Regenerated with enhancements

## Testing

Verified that:
- ✅ All 64 tables have two labels (fields + table name)
- ✅ All 63 relationships have cardinality labels
- ✅ Cardinality correctly reflects table structure:
  - Array relationships show "0..*"
  - Optional objects show "0..1"
  - Required objects show "1"
- ✅ GraphML file opens correctly in yEd Graph Editor
- ✅ Automatic layouts work properly
- ✅ Labels are editable and repositionable

