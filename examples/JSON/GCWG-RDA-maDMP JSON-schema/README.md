# GCWG-RDA-maDMP-JSON schema

## Intro

This folder contains the scripts to create JSON schemas and its corresponding uischemas. The published and temperary schemas are moved to [PublishedSchemas folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/PublishedSchemas) and [tempSchemas folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/PublishedSchemas/tempSchemas). 

## File Explained

1. `create_schema.py`: fetches the data from Orange Tab and transform it to machina actionable JSON schema.
   
2. `create_uischema.py`: also fetches data from Orange Tab and generates the uiSchema for corresponding JSON schema. Currently the only purpose of  (note: uiSchema is not offically used in JSON. It is introduced in RJSF to help render JSON schemas)

3. `schema_metadata.py` in [PublishedSchemas folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/PublishedSchemas): __name_n_version__ and __schema_path__ are required, __uischema_path__ can be empty string.


## Instructions to create a new version of maDMP

1. Install relevant libraries
   ```bash
   py -m pip install pandas numpy re json
   ```
2. Ensure that that the google sheet name is the same or updated to the relevant sheet name. For example, if <b>GC maDMP Master Sheet</b> is changed to a different name, please change the sheet name in the python code to reflect this. Additionally make sure that the input file has all columns in `kept_columns` variable in `create_schema.py`. If names are updated in the source sheet, please update the python code to reflect the changes. Whatsmore, the sheet's share property in the up right corner should also be set to "Anyone with the link".

3. Ensure that you have the correct ouput file names in the scripts.

4. Run the 2 Python scripts `create_schema.py` and `create_uischema.py`. If successfully completed, 2 JSON files should appear. Make sure you add them to the [GCWG-RDA-maDMP JSON-schema folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/GCWG-RDA-maDMP%20JSON-schema)

## Adding Schema Choices to maDMP Generation Form

 If you wish to add newly created schemas to the
  [maDMP Generation Form](https://fairerdata.github.io/maDMP-Generation-Form/), 
  you need to manually copy the schemas to the [PublishedSchemas folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/PublishedSchemas) or the [tempSchemas folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/PublishedSchemas/tempSchemas), and modify the name so it includes the version information. You must also add information of the generated files to _schema_metadata.json_ in [PublishedSchemas folder](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/examples/JSON/PublishedSchemas) in order for the [maDMP Generation Form](https://fairerdata.github.io/maDMP-Generation-Form/) to fetch it.


## Adding new keys to the JSON file
If you would like to add more keys for each field, the easiest method is to create a new column in the input file. And add these lines of code in the relevant locations of `create_schema.py`. 
In the `for _, row in df.iterrows():` loop
```python
new_key = row["new key"]
```
```python
if pd.notna(new_key):
   schema_object["newKeyName"] = new_key
```

## Differences between RDA Schema and GCWG-RDA-maDMP Schema
1. More fields
2. "question" key with the value being the front-end user-friendly question
3. "requiredWhen" key with the value being the neccessary nested data structures that are required. "requiredWhen" key is generated at the child level with the values being ancestors of the child.



