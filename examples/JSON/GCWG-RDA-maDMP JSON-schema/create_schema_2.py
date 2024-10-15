import pandas as pd
import json
import numpy as np
import urllib.parse
import re

"""
replace conditional require with conditional appear, add required_When_nested_structure_exist
"""

# Function to build a nested dictionary for a given path
def build_nested_dict(keys, value, parent_path):
    if len(keys) == 1:
        # Add the $id and title for the field
        value["$id"] = f"{parent_path}/properties/{keys[0]}"
        value["title"] = f"The {keys[0].capitalize()} schema"
        return {keys[0]: value}

    # Create an intermediate object for nested data structure
    nested_object = {
        "$id": f"{parent_path}/properties/{keys[0]}",
        "type": "object",
        "title": f"The {keys[0].capitalize()} Schema",
        "properties": {}
    }

    # Recursively build the nested object
    nested_object["properties"] = build_nested_dict(keys[1:], value, nested_object["$id"])

    return {keys[0]: nested_object}

# Function to merge dictionaries, handling cases where non-nested values exist
def merge_dicts(d1, d2):
    for key in d2:
        if key in d1 and isinstance(d1[key], dict) and isinstance(d2[key], dict):
            merge_dicts(d1[key], d2[key])
        else:
            d1[key] = d2[key]

# Function to merge the 'if then' expressions in conditional required dictionaries
def merge_conditional_required_dicts(conditional_required_dicts):
    for key, value in conditional_required_dicts.items():
        if value.__len__() > 1:
            merged = {}
            for item in value:
                # Convert the dictionary in 'key1' to a string (json) to make it hashable
                key1_as_str = json.dumps(item['if'], sort_keys=True)
                
                # Add the value of 'key2' to the corresponding 'key1'
                if key1_as_str not in merged:
                    merged[key1_as_str] = []
                merged[key1_as_str].append(item['then'])
            
            # Convert the string back to a dictionary
            merged_result = [{ 'if': json.loads(k), 'then': v} for k, v in merged.items()][0]
            #print(json.dumps(merged_result, indent=4))

            # now merge the required fields in 'then' dictionaries
            merge_required = {"required": []}
            # Iterate over each dictionary and extend the 'required' list
            for d in merged_result["then"]:
                merge_required["required"].extend(d["required"])
            
            #print(json.dumps(merge_required, indent=4))

            # Add the merged 'required' list to the 'then' dictionary
            merged_result["then"] = merge_required
            #print(json.dumps(merged_result, indent=4))

            conditional_required_dicts[key] = merged_result


# Load the CSV file (adjust the path as necessary)
google_sheet_id = '1OfY5dKEfbvFhlhBjRb4UfdPKqQiB9mjZwe_60R7mu-A' #'1OfY5dKEfbvFhlhBjRb4UfdPKqQiB9mjZwe_60R7mu-A'
worksheet_name = 'GC maDMP Master Sheet'
# URL-encode the worksheet name
encoded_worksheet_name = urllib.parse.quote(worksheet_name)
# Construct the URL for the CSV export
url = f'https://docs.google.com/spreadsheets/d/{google_sheet_id}/gviz/tq?tqx=out:csv&sheet={encoded_worksheet_name}'

# Read the data into a pandas DataFrame
df = pd.read_csv(url, encoding='utf-8')

# Columns that are necessary to generate the schema
kept_columns = ["Data type", "Common standard fieldname\n(click on blue hyperlinks for RDA core maDMP field descriptions)",
                'Allowed Values\n(for JSON schema file)', 'Example value', 'Description', 
                'Front-end user-friendly question', 'GC DMP Requirement', 'required when',
                ## newly added column
                '"required IF/WHEN" dependency', 'Cardinality', 'conditional appear prerequisite path', 
                'conditional appear prerequisite value'
                ]

# Adjust data types based on patterns
df["Data type"] = np.where(df["Data type"].str.contains('controlled vocabulary', case=True, na=False), "controlled vocabulary", df['Data type'])
df["Data type"] = np.where(df["Data type"].str.contains('DateTime.', case=True, na=False), "date-time", df['Data type'])
df["Data type"] = np.where(df["Data type"].str.contains('Date.', case=True, na=False), "date", df['Data type'])
df["Data type"] = np.where(df["Data type"].str.contains('string', case=True, na=False), "string", df['Data type'])

df["Common standard fieldname\n(click on blue hyperlinks for RDA core maDMP field descriptions)"] = df["Common standard fieldname\n(click on blue hyperlinks for RDA core maDMP field descriptions)"].str.rstrip("/")
df['format'] = None

# Set the format based on data type
df.loc[df['Data type'] == 'date', 'format'] = 'date'
df.loc[df['Data type'] == 'date-time', 'format'] = 'date-time'
df.loc[df['Data type'] == 'URI', 'format'] = 'uri'
df.loc[df['Common standard fieldname\n(click on blue hyperlinks for RDA core maDMP field descriptions)'].str.contains('mbox', case=False, na=False), 'format'] = 'email'

# Initialize the base schema
json_schema = {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "https://github.com/FAIRERdata/maDMP-Standard/blob/Master/examples/JSON/GCWG-RDA-maDMP JSON-schema/GCWG-RDA-maDMP-schema.json",  # Update this to the appropriate $id
    "title": "GCWG-RDA-maDMP-Schema",  # schema title
    "type": "object",
    "properties": {},
    "additionalProperties": False,
    "required": ["dmp"]  # Add "dmp" to the top-level required array
}

# A dictionary to track the required fields at each level
required_fields_dict = {}
## newly added column
conditional_appear_dict = {}
one_to_n_array_list = []
zero_to_n_array_list = []
require_when_nested_structure_exist = {}

# Iterate through each row and construct the schema
for _, row in df.iterrows():
    field_path = row['Common standard fieldname\n(click on blue hyperlinks for RDA core maDMP field descriptions)'].split('/')
    data_type = row['Data type'].lower()  # Convert to lowercase for easier matching
    allowed_values = row['Allowed Values\n(for JSON schema file)']
    example_value = row['Example value']
    description = row['Description']
    question = row['Front-end user-friendly question']
    format = row['format']
    requirement = row['GC DMP Requirement']  # New column for requirement
    required_when = row['required when']
    ## newly added column
    required_IF_dependency = row[' "required IF/WHEN" dependency']
    cardinality = row['Cardinality']
    prerequisite_path = row['conditional appear prerequisite path']
    prerequisite_values = row['conditional appear prerequisite value']

    '''
        conditional appear:
            if certain value(s) is selected, then some sub-schema are shown, others are hiden
            Example: business
    '''

    # delete
    if "approval" not in field_path: # and "approval" not in field_path:
        continue

    parent_path = "/".join(field_path[:-1])
    child_name = field_path[-1]

    # Determine JSON schema type based on the data type
    if "date_time" in data_type:
        json_type = "string"
    elif "date" in data_type:
        json_type = "string"
    elif "nested data structure" in data_type:
        json_type = "object"
    elif data_type == "controlled vocabulary":
        json_type = "string"
    elif data_type == "uri":
        json_type = "string"  # JSON schema uses string for URIs
    else:
        json_type = data_type

    # Build the schema object for the current field
    schema_object = {
        "type": json_type
    }

    # Add Description if not empty
    if pd.notna(description) and description.strip():
        schema_object["description"] = description

    if pd.notna(allowed_values):
        schema_object["enum"] = [v.strip() for v in allowed_values.split(',')]

    if pd.notna(example_value):
        schema_object["example"] = example_value

    if pd.notna(question):
        schema_object["question"] = question

    if pd.notna(format):
        schema_object["format"] = format

    if pd.notna(required_when):
        schema_object["requiredWhen"] = [v.strip() for v in required_when.split(',')]
        if parent_path not in require_when_nested_structure_exist:
            require_when_nested_structure_exist[parent_path] = []
        require_when_nested_structure_exist[parent_path].append(child_name)
    

    # Check if the current field is required
    if pd.notna(requirement) and requirement.strip().lower() == 'required':
        #parent_path = "/".join(field_path[:-1])
        #child_name = field_path[-1]

        # Add the child name to the required fields for the parent path
        if parent_path not in required_fields_dict:
            required_fields_dict[parent_path] = []
        required_fields_dict[parent_path].append(child_name)

    ## newly added column
    # build dependencies, check "required IF" condition
    if pd.notna(required_IF_dependency) and requirement.strip().lower() == 'required if':
        if pd.notna(prerequisite_path) and pd.notna(prerequisite_values):
            prerequisite = prerequisite_path.split('/')[-1]
            prerequisite_values = [x.strip() for x in prerequisite_values.split(',')]

            if parent_path not in conditional_appear_dict:
                conditional_appear_dict[parent_path] = []
            conditional_appear_dict[parent_path].append((child_name, prerequisite, prerequisite_values))
        else:
            print("Error: the required_IF_dependency is not in the correct format")


        
    
    # Check if the current field is an array (cardinality = 1..n)
    if pd.notna(cardinality) and cardinality.strip().lower() == '1..n':
        # check if all of the parents are not in the array_fields_list
        array_path = "/".join(field_path)
        all_not_in_dict = all( item not in array_path for item in one_to_n_array_list)
        if all_not_in_dict:
            one_to_n_array_list.append(array_path)
    
    # Check if the current field is an array (cardinality = 0..n)
    if pd.notna(cardinality) and cardinality.strip().lower() == '0..n':
        # check if all of the parents are not in the array_fields_list
        array_path = "/".join(field_path)
        all_not_in_dict = all( item not in array_path for item in zero_to_n_array_list)
        if all_not_in_dict:
            zero_to_n_array_list.append(array_path)

            
    # Create the nested dictionary for this field path, adding $id and title dynamically
    nested_dict = build_nested_dict(field_path, schema_object, "#")

    print(json.dumps(nested_dict, indent=4))

    # Merge the nested dictionary into the base schema properties
    merge_dicts(json_schema['properties'], nested_dict)
    #print("json_schema-----------------------------------")
    #print(json.dumps(json_schema, indent=4))
    #print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

#print(json.dumps(conditional_appear_dict, indent=4))

## merge 'if then' scripts inside conditional_required_dict
#merge_conditional_required_dicts(conditional_required_dict)
#print(json.dumps(conditional_required_dict, indent=4))







# Assign required fields to the correct parent objects in the JSON schema
def assign_required_fields(schema, path=""):
    if "properties" in schema:
        for prop_name, prop_value in schema["properties"].items():
            current_path = f"{path}/{prop_name}".strip("/")
            if current_path in required_fields_dict:
                prop_value["required"] = required_fields_dict[current_path]

            ## newly added column
            # add requiredWhen fields
            if current_path in require_when_nested_structure_exist:
                if "required" not in prop_value:
                    prop_value["required"] = []
                prop_value["required"].extend(require_when_nested_structure_exist[current_path])

            assign_required_fields(prop_value, current_path)

def apply_conditionals(schema, path=""):
    if "properties" in schema:
        for prop_name, prop_value in schema["properties"].items():
            current_path = f"{path}/{prop_name}".strip("/")
            # add conditional appear fields
            if current_path in conditional_appear_dict:
                #print(current_path)
                temp_list= []
                for child_name_pair in conditional_appear_dict[current_path]:
                    child_name = child_name_pair[0]
                    prerequisite = child_name_pair[1]
                    prerequisite_values = child_name_pair[2]
                    appearing_sub_schemas = {
                                        "if": {
                                            "properties": {
                                                prerequisite: {
                                                "enum": prerequisite_values
                                                }
                                            }
                                        },
                                        "then": {
                                            "properties": {
                                                child_name: prop_value["properties"].pop(child_name)
                                            },
                                            "required": [
                                                child_name
                                            ]
                                        }
                                    }
                    temp_list.append(appearing_sub_schemas)
                #print(json.dumps(temp_list, indent=4))
                if "allOf" not in prop_value:
                    prop_value["allOf"] = []
                prop_value["allOf"].extend(temp_list)

            # add requiredWhen fields
            #if current_path in require_when_nested_structure_exist:
            #    if "required" not in prop_value:
            #        prop_value["required"] = []
            #    prop_value["required"].extend(require_when_nested_structure_exist[current_path])


            apply_conditionals(prop_value, current_path)

# add array layer in schemas (move the properties into the array layer)
def add_array_layer(schema, path=""):
    if "properties" in schema:
        for prop_name, prop_value in schema["properties"].items():
            current_path = f"{path}/{prop_name}".strip("/")

            ## newly added column
            # add array layer 
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


assign_required_fields(json_schema)
apply_conditionals(json_schema)
add_array_layer(json_schema)

#print(json.dumps(conditional_required_dict, indent=4))
#print(json.dumps(conditional_appear_dict, indent=4))
#print(one_to_n_array_list)
#print(json.dumps(require_when_nested_structure_exist, indent=4))
#print(json.dumps(required_fields_dict, indent=4))


# Output the generated JSON schema as a JSON file or print it out
with open('test3_GCWG-RDA-maDMP-schema.json', 'w', encoding='utf-8') as f:
    json.dump(json_schema, f, indent=4, ensure_ascii=False)
"""
# Or, print it out to see the result
print(json.dumps(json_schema, indent=4))
"""