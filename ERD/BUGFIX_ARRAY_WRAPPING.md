# Bug Fix: Incorrect Array Wrapping for Primitive Fields

## Issue Description

The `create_schema.py` script was incorrectly wrapping primitive fields (string, number, date, etc.) in array structures when they had cardinality values of `1..n` or `0..n` in the Google Sheet.

### Examples of Affected Fields

**Before the fix:**
```json
"telephone": {
    "type": "array",
    "items": {
        "type": "number",
        "description": "Telephone number...",
        "$id": "#/properties/dmp/properties/contact/properties/telephone",
        "title": "Telephone"
    }
}
```

**After the fix:**
```json
"telephone": {
    "type": "number",
    "description": "Telephone number...",
    "$id": "#/properties/dmp/properties/contact/properties/telephone",
    "title": "Telephone"
}
```

### Fields Affected

The following primitive fields were incorrectly wrapped as arrays:

1. **Contact fields:**
   - `dmp/contact/telephone`
   - `dmp/contact/fax`

2. **Contributor fields:**
   - `dmp/contributor/role`
   - `dmp/contributor/telephone`
   - `dmp/contributor/fax`

3. **Dataset fields:**
   - `dmp/dataset/keyword`
   - `dmp/dataset/supported_works_url`
   - `dmp/dataset/data_quality_assurance`
   - `dmp/dataset/mulitple_language`

4. **Disposition planning fields:**
   - `dmp/dataset/disposition_planning/disposition_review_next`
   - `dmp/dataset/disposition_planning/retention_specification/trigger_type`
   - `dmp/dataset/disposition_planning/retention_specification/trigger_description`
   - `dmp/dataset/disposition_planning/retention_specification/retention_rationale`
   - `dmp/dataset/disposition_planning/retention_specification/retention_period_end_date`

5. **Distribution fields:**
   - `dmp/dataset/distribution/data_security-privacy_measures`
   - `dmp/dataset/distribution/preservation_flag`
   - `dmp/dataset/distribution/format`
   - `dmp/dataset/distribution/host/pid_system`
   - `dmp/dataset/distribution/host/language`
   - `dmp/dataset/distribution/online_service/language`
   - `dmp/dataset/distribution/data_integrity/perfomed`

6. **Technical resource fields:**
   - `dmp/dataset/technical_resource/data_management_system/pid_system`
   - `dmp/dataset/technical_resource/data_management_system/authentication`
   - `dmp/dataset/technical_resource/data_management_system/storage_type`
   - `dmp/dataset/technical_resource/data_management_system/compliance_standards`
   - `dmp/dataset/technical_resource/software/dependencies`

7. **Other fields:**
   - `dmp/project/funding/source/type`
   - `dmp/dataset/intellectual_property/copyright_holder`
   - `dmp/indigenous_considerations/group_identification`
   - `dmp/indigenous_considerations/research_method`
   - `dmp/indigenous_considerations/indian_band_name`
   - `dmp/indigenous_considerations/indian_band_number`

**Total:** 33 primitive fields were incorrectly wrapped as arrays

## Root Cause

The `add_array_layer()` function in `create_schema.py` (lines 364-394) was wrapping **all** fields with cardinality `1..n` or `0..n` into array structures, without checking whether the field was:
- An **object** (which should be wrapped in an array)
- A **primitive** (which should NOT be wrapped in an array)

### Original Code (Buggy)

```python
def add_array_layer(schema, path=""):
    if "properties" in schema:
        for prop_name, prop_value in schema["properties"].items():
            current_path = f"{path}/{prop_name}".strip("/")

            if current_path in one_to_n_array_list:
                schema["properties"][prop_name] = {
                    'type': 'array',
                    'items': prop_value,
                    'minItems': 1
                }

            if current_path in zero_to_n_array_list:
                schema["properties"][prop_name] = {
                    'type': 'array',
                    'items': prop_value
                }

            add_array_layer(prop_value, current_path)
```

This code wrapped **every** field in the cardinality lists, regardless of type.

## Solution

Modified the `add_array_layer()` function to check if a field is an object (has `"properties"` or `"type": "object"`) before wrapping it in an array.

### Fixed Code

```python
def add_array_layer(schema, path=""):
    if "properties" in schema:
        for prop_name, prop_value in schema["properties"].items():
            current_path = f"{path}/{prop_name}".strip("/")

            # Only wrap in array if the field is an object (has "properties")
            # Primitive fields (string, number, etc.) should NOT be wrapped in arrays
            # even if they have cardinality 1..n or 0..n in the spreadsheet
            if current_path in one_to_n_array_list:
                # Check if this is an object with properties (not a primitive field)
                if "properties" in prop_value or prop_value.get("type") == "object":
                    schema["properties"][prop_name] = {
                        'type': 'array',
                        'items': prop_value,
                        'minItems': 1
                    }
                # else: primitive field - keep as-is, don't wrap in array

            if current_path in zero_to_n_array_list:
                # Check if this is an object with properties (not a primitive field)
                if "properties" in prop_value or prop_value.get("type") == "object":
                    schema["properties"][prop_name] = {
                        'type': 'array',
                        'items': prop_value
                    }
                # else: primitive field - keep as-is, don't wrap in array

            add_array_layer(prop_value, current_path)
```

## Impact on Database Schema

### Before the Fix
- **94 tables** were generated
- Primitive fields with cardinality `1..n` or `0..n` created separate junction tables
- Example: `dmp_contact_telephone` table with columns: `id`, `dmp_contact_id`, `value`, `array_index`

### After the Fix
- **64 tables** are generated (30 fewer tables!)
- Primitive fields are now columns in their parent tables
- Example: `dmp_contact` table includes `telephone NUMERIC` column

### Database Schema Improvements

**Before:**
```sql
CREATE TABLE dmp_contact (
    id SERIAL PRIMARY KEY,
    dmp_id INTEGER,
    name TEXT,
    mbox VARCHAR(2048),
    ...
);

CREATE TABLE dmp_contact_telephone (
    id SERIAL PRIMARY KEY,
    dmp_contact_id INTEGER NOT NULL,
    value NUMERIC,
    array_index INTEGER
);

CREATE TABLE dmp_contact_fax (
    id SERIAL PRIMARY KEY,
    dmp_contact_id INTEGER NOT NULL,
    value NUMERIC,
    array_index INTEGER
);
```

**After:**
```sql
CREATE TABLE dmp_contact (
    id SERIAL PRIMARY KEY,
    dmp_id INTEGER,
    name TEXT,
    mbox VARCHAR(2048),
    telephone NUMERIC,
    fax NUMERIC,
    ...
);
```

## Testing

To verify the fix:

1. **Regenerate the JSON schema:**
   ```bash
   cd JSON
   echo nan | python create_schema.py
   ```

2. **Check specific fields in the JSON schema:**
   ```bash
   # Should show "type": "number" (not "type": "array")
   grep -A 5 '"telephone"' GCWG-RDA-maDMP-schema.json
   ```

3. **Regenerate the database schema:**
   ```bash
   python generate_database_schema.py --input GCWG-RDA-maDMP-schema.json --output madmp_database_schema.sql --erd
   ```

4. **Verify no separate tables for primitive fields:**
   ```bash
   # Should return no results
   grep "CREATE TABLE.*telephone\|CREATE TABLE.*fax" madmp_database_schema.sql
   ```

5. **Verify fields are columns in parent tables:**
   ```bash
   # Should show telephone and fax as columns in dmp_contact
   grep -A 20 "CREATE TABLE dmp_contact" madmp_database_schema.sql
   ```

## Files Modified

- **`JSON/create_schema.py`** - Fixed the `add_array_layer()` function (lines 364-394)

## Files Regenerated

After applying the fix, the following files should be regenerated:

1. **`JSON/GCWG-RDA-maDMP-schema.json`** - JSON schema with corrected field types
2. **`JSON/madmp_database_schema.sql`** - Database schema with 64 tables (down from 94)
3. **`JSON/madmp_database_schema_erd.mmd`** - Mermaid ERD with corrected structure
4. **`JSON/madmp_database_schema_erd.graphml`** - GraphML ERD with corrected structure

## Validation Rule

**Rule:** A field should only be wrapped in an array if:
1. It has cardinality `1..n` or `0..n` in the Google Sheet, **AND**
2. It is an object type (has `"properties"` or `"type": "object"`)

**Primitive fields** (string, number, date, boolean, etc.) should **never** be wrapped in arrays, even if they have cardinality `1..n` or `0..n`.

## Future Considerations

If there's a legitimate need to store multiple values for a primitive field (e.g., multiple phone numbers), consider:

1. **Using a delimited string:** Store as `"123,456,789"` in a single TEXT column
2. **Using database-specific array types:** PostgreSQL supports native arrays like `INTEGER[]`
3. **Creating a separate junction table:** Only if truly needed for complex queries

For now, the fix assumes that primitive fields with cardinality `1..n` or `0..n` in the spreadsheet are **data entry errors** and should be treated as single-value fields.

