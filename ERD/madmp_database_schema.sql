-- Database schema generated from GCWG-RDA-maDMP JSON Schema
-- Generated on: 2025-01-04
-- Database type: postgresql

-- Table: dmp
-- Description: Root DMP object
-- Path: dmp
CREATE TABLE dmp (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key
);

-- Table: dmp_approval
-- Description: Approval of the maDMP
-- Path: dmp/approval
CREATE TABLE dmp_approval (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER  -- Foreign key to dmp,
    status VARCHAR(255)  -- Approval status for the DMP,
    description TEXT  -- To provide any free-form text information on the approval for the DMP,
    by_mbox VARCHAR(2048)  -- Email of the person who approved the maDMP
);

-- Table: dmp_contact
-- Description: Specifies the party which can provide information about the DMP. This is not necessarily the DMP creator, and it can be a person or an organization.
-- Path: dmp/contact
CREATE TABLE dmp_contact (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER  -- Foreign key to dmp,
    name TEXT  -- Name of the contact person or organization,
    mbox VARCHAR(2048)  -- E-mail address,
    role VARCHAR(255)  -- Role of the reponsible party.,
    url TEXT  -- On-line information that can be used to contact the responsible individual or organization. This element should be expressed as a URL that will guide the user to further information online. 
,
    organization TEXT  -- Organization the contact person is affiliated to. For Canadian Departments and agencies, conform with http://www.tbs-sct.gc.ca/fip-pcim/reg-eng.asp. Sub and sub-sub organization (sectors, branches, et,
    position TEXT  -- Position of the contact if contact is a person.,
    telephone NUMERIC  -- Telephone number by which individuals can speak to the responsible organization or individual
,
    fax NUMERIC  -- Telephone number of a facsimile machine for the responsible organization or individual.,
    delivery_point TEXT  -- Enter the street address for the responsible organization or individual
,
    city TEXT  -- City where the contact is located,
    postal_zip_code TEXT  -- ZIP or other postal code of the location
,
    hours_of_service TEXT  -- The time period (including time zone) when the organization or individual can be contacted

);

-- Table: dmp_contact_affiliation
-- Description: To provide information about the organization the contact is affiliated with
-- Path: dmp/contact/affiliation
CREATE TABLE dmp_contact_affiliation (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contact_id INTEGER NOT NULL  -- Foreign key to dmp_contact,
    array_index INTEGER  -- Position in the array,
    contact_affiliation_name TEXT  -- Name of the organization the contact is affiliated with
);

-- Table: dmp_contact_affiliation_contact_affiliation_id
-- Description: Details about the organization's ID
-- Path: dmp/contact/affiliation/contact_affiliation_id
CREATE TABLE dmp_contact_affiliation_contact_affiliation_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contact_affiliation_id INTEGER  -- Foreign key to dmp_contact_affiliation,
    registry_uri TEXT  -- Link to the identifier system used to identify the organization,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    type VARCHAR(255)  -- To specify what type the organization identifier is.,
    identifier TEXT  -- To indicate the specific value of the organization identifier 
);

-- Table: dmp_contact_affiliation_contact_country
-- Description: Country where the organization the contact is affiliated to, is located
-- Path: dmp/contact/affiliation/contact_country
CREATE TABLE dmp_contact_affiliation_contact_country (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contact_affiliation_id INTEGER  -- Foreign key to dmp_contact_affiliation,
    code VARCHAR(255)  -- The 2-letter code of the country, as per the ISO standard 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes,
    name TEXT  -- The name of the country, as per the ISO standard ISO 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes
);

-- Table: dmp_contact_affiliation_contact_province_state
-- Description: Province or state of the organization the contact is affiliated to.
-- Path: dmp/contact/affiliation/contact_province_state
CREATE TABLE dmp_contact_affiliation_contact_province_state (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contact_affiliation_id INTEGER  -- Foreign key to dmp_contact_affiliation,
    code TEXT  -- The 3-letter code of the province or state, as per the ISO standard 3166-2 Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code,
    name TEXT  -- The name of the province or state, as per the ISO standard ISO 3166-2 Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code
);

-- Table: dmp_contact_contact_id
-- Description: Persistent identifier associated with the contact
-- Path: dmp/contact/contact_id
CREATE TABLE dmp_contact_contact_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contact_id INTEGER  -- Foreign key to dmp_contact,
    identifier TEXT  -- To indicate the specific value of the contact’s  identifier,
    type VARCHAR(255)  -- To specify what type the contact’s  identifier is. It is recommended to use ORCID identifiers for scientists and researchers.,
    registry_url TEXT  -- Link to the identifier system used to identify the contact,
    registry_version TEXT  -- To indicate the version number or date when the system was consulted
);

-- Table: dmp_contributor
-- Description: Party involved in the process of data management described by the DMP, or party involved in the creation and management of the DMP itself.
-- Path: dmp/contributor
CREATE TABLE dmp_contributor (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER NOT NULL  -- Foreign key to dmp,
    array_index INTEGER  -- Position in the array,
    name TEXT  -- Name of the contributor,
    role TEXT  -- To specify contributors’ role(s) within the data management process, including planning. It is recommended to list contributor roles according to the <a href="https://datacite-metadata-schema.readthed,
    mbox VARCHAR(2048)  -- To provide an E-mail address of the contributor,
    position TEXT  -- Role or position of the contributor or cited responsible party,
    telephone NUMERIC  -- Telephone number by which individuals can speak to the contributor or cited reponsible party,
    fax NUMERIC  -- Telephone number of a facsimile machine for the contributor or cited responsible party,
    delivery_point TEXT  -- Enter the street address for the contributor or the cited responsible party,
    city TEXT  -- City where the contributor is located,
    postal_zip_code TEXT  -- ZIP or other postal code of the location,
    url TEXT  -- On-line information that can be used to contact the contributor or the cited responsible party. This element should be expressed as a URL that will guide the user to further information online. 
,
    hours_of_service TEXT  -- The time period (including time zone) when the contributor or the cited responsible party can be contacted

);

-- Table: dmp_contributor_affiliation
-- Description: Provide information about the organization the contributor is affiliated with 
-- Path: dmp/contributor/affiliation
CREATE TABLE dmp_contributor_affiliation (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contributor_id INTEGER NOT NULL  -- Foreign key to dmp_contributor,
    array_index INTEGER  -- Position in the array,
    contributor_affiliation_name TEXT  -- Name of the organization the contributor is affiliated with
);

-- Table: dmp_contributor_affiliation_contributor_affiliation_id
-- Description: Details about the organization's ID
-- Path: dmp/contributor/affiliation/contributor_affiliation_id
CREATE TABLE dmp_contributor_affiliation_contributor_affiliation_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contributor_affiliation_id INTEGER  -- Foreign key to dmp_contributor_affiliation,
    identifier TEXT  -- To indicate the specific value of the organization identifier ,
    type VARCHAR(255)  -- To specify what type the organization identifier is.,
    registry_url TEXT  -- Link to the identifier system used to identify the organization,
    registry_version TEXT  -- To indicate the version number or date of the reference
);

-- Table: dmp_contributor_affiliation_contributor_country
-- Description: Country where the organization is located
-- Path: dmp/contributor/affiliation/contributor_country
CREATE TABLE dmp_contributor_affiliation_contributor_country (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contributor_affiliation_id INTEGER  -- Foreign key to dmp_contributor_affiliation,
    name TEXT  -- The name of the country, as per the ISO standard ISO 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes,
    code VARCHAR(255)  -- The 2-letter code of the country, as per the ISO standard 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes
);

-- Table: dmp_contributor_affiliation_contributor_province_state
-- Description: Province or state of the organization the contributor is affiliated with
-- Path: dmp/contributor/affiliation/contributor_province_state
CREATE TABLE dmp_contributor_affiliation_contributor_province_state (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contributor_affiliation_id INTEGER  -- Foreign key to dmp_contributor_affiliation,
    name TEXT  -- The name of the province or state, as per the ISO standard ISO 3166-2  Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code,
    code TEXT  -- The 3-letter code of the province or state, as per the ISO standard 3166-2 Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code
);

-- Table: dmp_contributor_contributor_id
-- Description: Persistent identifier associated with the contributor
-- Path: dmp/contributor/contributor_id
CREATE TABLE dmp_contributor_contributor_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_contributor_id INTEGER  -- Foreign key to dmp_contributor,
    type VARCHAR(255)  -- To specify what type the contributor’s identifier is. It is recommended to use ORCID ID for scientists and researchers.,
    registry_url TEXT  -- Link to the identifier system used to identify the contributor,
    registry_version TEXT  -- To indicate the version number or date when the system was consulted,
    identifier TEXT  -- To indicate the specific value of the contributor’s identifier 
);

-- Table: dmp_cost
-- Description: To list costs related to data management. Providing multiple instances of a 'Cost' allows to break down costs into details. Providing one 'Cost' instance allows to provide one aggregated sum.
-- Path: dmp/cost
CREATE TABLE dmp_cost (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER NOT NULL  -- Foreign key to dmp,
    array_index INTEGER  -- Position in the array,
    title TEXT  -- To give a title or name to identify the specific cost that is described in this section,
    description TEXT  -- To provide additional details about a cost, including specifying which activities or resources it relates to, such as making data FAIR, ensuring data accessibility, or enhancing its reusability.,
    value NUMERIC  -- Cost value in the specified currency 
);

-- Table: dmp_cost_cost_documentation
-- Description: Any external material documenting the costing details.
-- Path: dmp/cost/cost_documentation
CREATE TABLE dmp_cost_cost_documentation (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_cost_id INTEGER NOT NULL  -- Foreign key to dmp_cost,
    array_index INTEGER  -- Position in the array,
    name TEXT  -- Title of the external document documenting the  cost,
    access_url TEXT  -- A URL of that gives access to the costdocumentation. e.g., landing page, feed, SPARQL endpoint. The access URL should be used for the URL of a service or location that can provide access to cost docum,
    download_url TEXT  -- Download URL to the cost documentation
);

-- Table: dmp_dataset
-- Description: To describe data on a non-technical level.
-- Path: dmp/dataset
CREATE TABLE dmp_dataset (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER NOT NULL  -- Foreign key to dmp,
    array_index INTEGER  -- Position in the array,
    title TEXT  -- Title is a property in both Dataset and Distribution, in compliance with W3C DCAT. In some cases these might be identical, but in most cases the Dataset represents a more abstract concept, while the d,
    description TEXT  -- Description is a property in both Dataset and Distribution, in compliance with W3C DCAT. In some cases these might be identical, but in most cases the Dataset represents a more abstract concept, while,
    keyword TEXT  -- Keyword,
    type TEXT  -- If appropriate, type according to: DataCite and/or COAR dictionary. Otherwise use the common name for the type, e.g. raw data, software, survey, etc. <a href="https://schema.datacite.org/meta/kernel-4,
    general_data_format VARCHAR(255)  -- Main format of the dataset according to DDI General_DATA_Format controlled vocabulary  <a href="https://rdf-vocabulary.ddialliance.org/ddi-cv/GeneralDataFormat/2.0.3/GeneralDataFormat.html.">rdf-vocab,
    geodetic_datum VARCHAR(255)  -- If the dataset contains geospatial data, indicate the geodetic datum (coordinate reference system),
    geographic_coverage TEXT  -- The geographical area covered by a geospatial dataset,
    data_completeness VARCHAR(255)  -- Dataset percentage completeness ,
    issued DATE  -- To indicate a date when a dataset was published or released. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    language VARCHAR(255)  -- Language of the dataset expressed using ISO 639-3,
    data_criticality TEXT  -- To indicate how important the data are for the organization to achieve its goals. Example values: business function continuity and improvement, IM or IT modernization, intergovernmental agreement, min,
    data_governance_description TEXT  -- Indicate if there is a data governance framework like, for example, a specified departmental data governance framework, and/or if data governance is aligned with published principles such as the CARE ,
    personal_data VARCHAR(255)  -- To indicate whether a dataset contains personal data. Personal data refers to any data that can identify an individual (e.g. name, birthdate, address, voice recordings, etc.).,
    sensitive_data VARCHAR(255)  -- Sensitive data are data for which injury that could reasonably be expected as a result of a loss of confidentiality (resulting from unauthorized disclosure), loss of integrity (resulting from unauthor,
    preservation_statement TEXT  -- Preservation Statement. Details concerning retention and disposition should be provided in dmp/dataset/disposition_planning/,
    supported_works_url TEXT  -- An URL or DOI that gives access to the supported work.,
    data_quality_assurance TEXT  -- To describe any quality assurance processes applied to a dataset, such as, to ensure its accuracy, reliability, consistency, and usability for its intended purposes. This includes systematic practices,
    disclaimer TEXT  -- limitation affecting the fitness for use of the resource or metadata,
    disposition_completed DATE  -- Date on which disposition effected. Encoded using the ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    dataset_is_reused BOOLEAN  -- Indication if the dataset is reused, i.e., not produced in project(s) covered by this DMP.,
    mulitple_language VARCHAR(255)  -- Language of the dataset expressed using ISO 639-3. If the ISO code mul (multiple languages) is used, please also complete the multiple_language field to list the specific languages.
);

-- Table: dmp_dataset_collection
-- Description: Information on how the data is collected.
-- Path: dmp/dataset/collection
CREATE TABLE dmp_dataset_collection (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER  -- Foreign key to dmp_dataset,
    description TEXT  -- To describe the data collection processes,
    data_earliest_date DATE  -- The earliest date in the case of time series data. Encoded using the ISO 8601 Date  <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    data_latest_date DATE  -- For time series data, date of the latest data in the series. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    dataset_update_frequency VARCHAR(255)  -- The update frequency of the data in the dataset,
    dataset_last_updated DATE  -- Date when the dataset was last updated. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    dataset_size NUMERIC  -- Size of the dataset from which distributions are derived.,
    dataset_size_units VARCHAR(255)  -- Dataset size units,
    growth_annual_terabytes NUMERIC  -- The dataset annual growth rate in terabytes per year. Important information needed when planning storage and associated budget,
    growth_end_date DATE  -- Date on which data collection for this dataset is expected to cease
);

-- Table: dmp_dataset_creator
-- Description: To specify the creators of the dataset
-- Path: dmp/dataset/creator
CREATE TABLE dmp_dataset_creator (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    mbox VARCHAR(2048)  -- To provide an E-mail address of the creator,
    name TEXT  -- Name of the creator
);

-- Table: dmp_dataset_creator_affiliation
-- Description: To provide information about the organization(s) the creator is affiliated to
-- Path: dmp/dataset/creator/affiliation
CREATE TABLE dmp_dataset_creator_affiliation (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_creator_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_creator,
    array_index INTEGER  -- Position in the array,
    creator_affiliation_name TEXT
);

-- Table: dmp_dataset_creator_affiliation_creator_affiliation_id
-- Path: dmp/dataset/creator/affiliation/creator_affiliation_id
CREATE TABLE dmp_dataset_creator_affiliation_creator_affiliation_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_creator_affiliation_id INTEGER  -- Foreign key to dmp_dataset_creator_affiliation,
    registry_url TEXT,
    registry_version TEXT,
    type VARCHAR(255),
    identifier TEXT
);

-- Table: dmp_dataset_creator_affiliation_creator_country
-- Description: Country where the organization the contributor is affiliated to, is located
-- Path: dmp/dataset/creator/affiliation/creator_country
CREATE TABLE dmp_dataset_creator_affiliation_creator_country (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_creator_affiliation_id INTEGER  -- Foreign key to dmp_dataset_creator_affiliation,
    code VARCHAR(255)  -- The 2-letter code of the country, as per the ISO standard 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes,
    name TEXT  -- The name of the country, as per the ISO standard ISO 3166-1 Codes for the representation of names of countries and their subdivisions – Part 1: Country codes
);

-- Table: dmp_dataset_creator_affiliation_creator_province_state
-- Description: Province or state of the organization the contributor is affiliated to.
-- Path: dmp/dataset/creator/affiliation/creator_province_state
CREATE TABLE dmp_dataset_creator_affiliation_creator_province_state (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_creator_affiliation_id INTEGER  -- Foreign key to dmp_dataset_creator_affiliation,
    code TEXT  -- The 3-letter code of the province or state, as per the ISO standard 3166-2 Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code,
    name TEXT  -- The name of the province or state, as per the ISO standard ISO 3166-2 Codes for the representation of names of countries and their subdivisions – Part 2: Country subdivision code
);

-- Table: dmp_dataset_creator_creator_id
-- Description: Identifier associated with the creator
-- Path: dmp/dataset/creator/creator_id
CREATE TABLE dmp_dataset_creator_creator_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_creator_id INTEGER  -- Foreign key to dmp_dataset_creator,
    identifier TEXT  -- To indicate the specific value of the creator''s identifier,
    registry_url TEXT  -- Link to the reference used to identify the creator,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    type VARCHAR(255)  -- To specify what type the creator’s identifier is. It is recommended to use ORCID identifiers for scientists and researchers.
);

-- Table: dmp_dataset_dataset_documentation
-- Description: Repeat as many times as needed to list all existing documentation, procedures for data processing, management, analysis and dissemination; for example: code book, contract, data dictionary, data produ
-- Path: dmp/dataset/dataset_documentation
CREATE TABLE dmp_dataset_dataset_documentation (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    name TEXT  -- Document name,
    description TEXT  -- To describe the documentation of the dataset,
    access_url TEXT  -- A URL of that gives access to the dataset documentation. e.g., landing page, feed, SPARQL endpoint. The access URL should be used for the URL of a service or location that can provide access to datase,
    download_url TEXT  -- Download URL to the dataset documentation
);

-- Table: dmp_dataset_dataset_id
-- Description: Identifier associated with the dataset
-- Path: dmp/dataset/dataset_id
CREATE TABLE dmp_dataset_dataset_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER  -- Foreign key to dmp_dataset,
    identifier TEXT  -- To indicate the specific value of the dataset ID,
    type VARCHAR(255)  -- To specify what type the dataset ID is.,
    registry_url TEXT  -- Link to the registry or system used to identify the dataset,
    registry_version TEXT  -- To indicate the version number or date when the system or registry was consulted
);

-- Table: dmp_dataset_disposition_action
-- Description: Used to document disposition that has been effected in relation to a dataset. Note: when all data associated with a dataset has been disposed, also indicate this in “dmp/dataset/disposition_completed.
-- Path: dmp/dataset/disposition_action
CREATE TABLE dmp_dataset_disposition_action (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    type VARCHAR(255)  -- Indicate the type of action taken to dispose of the data (scope of the data to be detailed in the description field),
    description TEXT  -- To document the scope of disposition action effected, as well as other details when required (e.g., means, issues).,
    authorization TEXT  -- Indicate disposition authorization number and details when available. May also be used to document internal signoff.,
    date DATE  -- Date on which disposition effected. Encoded using the ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>
);

-- Table: dmp_dataset_disposition_planning
-- Description: Used to document information in anticipation of a future disposition review. 
Note: does not document disposition actions actually effected.
-- Path: dmp/dataset/disposition_planning
CREATE TABLE dmp_dataset_disposition_planning (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER  -- Foreign key to dmp_dataset,
    retention_schedule_url TEXT  -- A URL that leads to the applicable retention schedule,
    archival_value VARCHAR(255)  -- Archival value according to the national archives. (Applies to records only.) 
For the Government of Canada, refer to definition of government records in the Library and Archives of Canada Act. Nevert,
    archival_value_description TEXT  -- Indicates nature and scope of the data with archival value according to national archives.,
    disposition_planning_last_reviewed DATE  -- To record the most recent date on which the values entered in disposition planning properties were reviewed. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">comp,
    disposition_review_next DATE  -- To record the next date(s) on which the dataset should be reviewed for disposition. (This may be the end of a retention period, the date on which a disposition impediment will be lifted, or some other
);

-- Table: dmp_dataset_disposition_planning_disposition_impediment
-- Description: For noting time-limited impediments to effecting disposition at the end of the dataset's retention period. Note: use the retention specification nest to indicate an indefinite retention period or a pe
-- Path: dmp/dataset/disposition_planning/disposition_impediment
CREATE TABLE dmp_dataset_disposition_planning_disposition_impediment (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_disposition_planning_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_disposition_planning,
    array_index INTEGER  -- Position in the array,
    type VARCHAR(255)  -- To indicate the type of impediment to disposition.,
    description TEXT  -- Include the name of the litigation, software, etc. where applicable.
Note: if there is a known end date to the disposition impediment, consider entering it in “dmp/dataset/disposition_planning/disposi
);

-- Table: dmp_dataset_disposition_planning_retention_specification
-- Path: dmp/dataset/disposition_planning/retention_specification
CREATE TABLE dmp_dataset_disposition_planning_retention_specification (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_disposition_planning_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_disposition_planning,
    array_index INTEGER  -- Position in the array,
    description TEXT  -- Indicates how long a dataset should be retained, and why. In instances of determinate retention, a retention specification includes three elements: a retention period; a retention period initiator (tr,
    trigger_type VARCHAR(255)  -- To indicate the type of trigger ,
    trigger_description TEXT  -- A trigger (retention period initiator) is an event in time that begins a retention period.,
    retention_rationale TEXT  -- The reason (justification) for retaining a dataset for a particular period of time.,
    retention_period_duration TEXT  -- To record duration of retention period after trigger event. (At the end of its retention period, the dataset should be reviewed for disposition, and disposition effected if possible.) Encoded using th,
    retention_period_end_date DATE  -- To record a fixed date marking the end of a retention period. Note the end of its retention period, the dataset should be reviewed for disposition, and disposition effected if possible. Encoded using ,
    required_perpetual_use VARCHAR(255)  -- Examples where this may be required include the need to maintain scientific integrity, treaties, agreements, or compliance with UN Joinet-Orentlicher principles for the protection and promotion of hum,
    required_destruction VARCHAR(255)  -- To indicate that a dataset must be destroyed.
Note: context can be recorded in “retention_specifications/description.”,
    trigger_occured DATE  -- The date on which the trigger was triggered, and the retention period began. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>.
);

-- Table: dmp_dataset_distribution
-- Description: To provide technical information on a specific instance of data.
-- Path: dmp/dataset/distribution
CREATE TABLE dmp_dataset_distribution (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    title TEXT  -- Title is a property in both Dataset and Distribution, in compliance with W3C DCAT. In some cases these might be identical, but in most cases the Dataset represents a more abstract concept, while the d,
    description TEXT  -- Description is a property in both Dataset and Distribution, in compliance with W3C DCAT. In some cases these might be identical, but in most cases the Dataset represents a more abstract concept, while,
    created DATE  -- Date of creation of the distribution. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    issued DATE  -- Date of the publication of the distribution. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    update_frequency VARCHAR(255)  -- The maintenance and update frequency of the distribution,
    status VARCHAR(255)  -- Completion status of the distribution,
    status_description TEXT  -- Description of the distribution completion status ,
    available_until DATE  -- Indicates how long this distribution will be/should be available. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    start_date DATE  -- Date of the oldest data in the distribution. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    end_date DATE  -- Date of the most recent data in the distribution. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    spatial_representation_type VARCHAR(255)  -- Spatial representation type of the data,
    character_encoding_standard VARCHAR(255)  -- Character encoding standard used in the distribution,
    character_unicode_block_code VARCHAR(255)  -- Unicode block used in the distribution. Use the "code" from the Unicode Standard 15.1. <a href="https://en.wikipedia.org/wiki/Unicode_block#List_of_blocks">en.wikipedia.org</a>,
    character_unicode_block_name VARCHAR(255)  -- Unicode block used in the distribution. Use the "name" from the Unicode Standard 15.1. <a href="https://en.wikipedia.org/wiki/Unicode_block#List_of_blocks">en.wikipedia.org</a>,
    quality_control_level VARCHAR(255)  -- Data quality control level. LEVEL 0 (Raw data or minimally processed data. Contains all available measurement data. May contain quality control flags indicating missing or invalid data. LEVEL 1 (A com,
    data_access VARCHAR(255)  -- OPEN ACCESS: available to anyone based on an open license (e.g., CC0, CC-BY, Open Government License). SHARED ACCESS: Public access with a license that limits use, that is available to anyone under te,
    linked_data_star_rating VARCHAR(255)  -- To rate the level of openness of the dataset according to the Tim Berners-Lee (founder of the World Wide Web) 5-star rating system for open data. To score the maximum five stars, data must (1) be avai,
    openness_other_rating TEXT  -- To rate the level of openness of the dataset according to a system other than the Tim Berner-Lees system, described in dmp/dataset/openness_other_rating_system.,
    openness_other_rating_system TEXT  -- Describe which system is used to rate the dataset openness when it''s not the Tim Berners-Lee 5-star rating system.,
    protection_level VARCHAR(255)  -- Protected information is not classified. Information is "protected" when unauthorized disclosure could reasonably be expected to cause injury to a non-national interest (i.e., an individual interest s,
    security_classification_level VARCHAR(255)  -- Security classification that designates the level of protection against access the data or information requires when unauthorized disclosure could reasonably be expected to cause injury to the nationa,
    data_security_privacy_measures TEXT  -- To provide any free-form text information about security or privacy measures.,
    preservation_flag VARCHAR(255)  -- To flag distributions for digital preservation attention purposes.,
    disposition_completed DATE  -- Indicates the date on which the distribution was disposed. (That is, the data lifecycle is complete, at the institution). 
In instances in which data was never created in relation to a planned distrib,
    format TEXT  -- Format according to: <a href="https://www.iana.org/assignments/media-types/media-types.xhtml">www.iana.org</a> if appropriate, otherwise use the common name for this format.<a href="https://www.iana.o,
    file_path TEXT  -- File path is for files that are available internally on shared drives but are not published on the internet. File paths using backslashes instead of forward slashes used for urls.,
    access_url TEXT  -- A URL that gives access to the distribution. e.g., landing page, feed, SPARQL endpoint. The access URL should be used for the URL of a service or location that can provide access to the distribution, ,
    download_url TEXT  -- The URL of the downloadable file in a given format. E.g. CSV file or RDF file.,
    byte_size NUMERIC  -- Size of the  distribution in bytes,
    data_size NUMERIC  -- The RDA standard requires describing size in bytes. However, byte_size does not provide a meaningful number for large files (e.g., a file that would typically be expressed in petabytes). Also, other s,
    data_size_units VARCHAR(255)  -- The RDA standard requires describing size in bytes. However, byte_size does not provide a meaningful number for large files (e.g., a file that would typically be expressed in petabytes). Also, other s
);

-- Table: dmp_dataset_distribution_data_integrity
-- Path: dmp/dataset/distribution/data_integrity
CREATE TABLE dmp_dataset_distribution_data_integrity (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER  -- Foreign key to dmp_dataset_distribution,
    output TEXT  -- To indicate the output of the checksum or the hash function,
    function_name TEXT  -- To indicate the name of the function or method used to check data integrity,
    perfomed TEXT  -- Date the checksome or hash was performed,
    notes DATE  -- to indicate any information about automation or planning
);

-- Table: dmp_dataset_distribution_distribution_id
-- Description: ID for the distribution
-- Path: dmp/dataset/distribution/distribution_id
CREATE TABLE dmp_dataset_distribution_distribution_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER  -- Foreign key to dmp_dataset_distribution,
    type TEXT  -- Identifier type,
    registry_url TEXT  -- Link to the reference used to identify the distribution,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    identifier TEXT  -- Identifier for the dataset distribution
);

-- Table: dmp_dataset_distribution_geographic_bounding_box
-- Description: Rectangular spatial extent that encompasses all the geographic locations represented in the data
-- Path: dmp/dataset/distribution/geographic_bounding_box
CREATE TABLE dmp_dataset_distribution_geographic_bounding_box (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER  -- Foreign key to dmp_dataset_distribution,
    north TEXT  -- The northernmost point of the area covered by the dataset, expressed in degrees of latitude,
    east TEXT  -- The easternmost point of the area covered by the dataset, expressed in degrees of latitude,
    south TEXT  -- The southernmost point of the area covered by the dataset, expressed in degrees of latitude,
    west TEXT  -- The westernmost point of the area covered by the dataset, expressed in degrees of latitude
);

-- Table: dmp_dataset_distribution_host
-- Description: The host is the system where the data are stored and processed. Be sure to also fill in a physical data asset section to indicate in which the data are hosted especially in which country the server is
-- Path: dmp/dataset/distribution/host
CREATE TABLE dmp_dataset_distribution_host (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER  -- Foreign key to dmp_dataset_distribution,
    title TEXT  -- The name of the system hosting the dataset for external access,
    description TEXT  -- To describe the host of the distribution,
    url TEXT  -- The URL of the system hosting a distribution of a dataset,
    storage_type VARCHAR(255)  -- The type of storage, including whether the host supports versioning of data distributions,
    pid_system VARCHAR(255)  -- Persistent identifier system used by the host,
    support_checksum VARCHAR(255)  -- To indicate if checksums can be performed to ensure integrity of the distribution,
    data_priority TEXT  -- Indicate if the data are active data, longterm storage, or transitory. For batch priority-based scheduling, declare relative priorities to determine the processing order of jobs and business processes,
    availability TEXT  -- Defines whether the data host is operational 24/7 or has downtime periods. (preferably as a percentage),
    backup_frequency TEXT  -- Frequency of backups provided by a host,
    backup_type TEXT  -- Type of backup of the host (e.g., incremental, full, differential, synthetic full) and/or backup location.,
    certified_with TEXT  -- To indicate host trustworthiness via a standard repository standard or certificate (e.g., ISO 27001, CoreTrustSeal, etc.),
    data_transfer_maximum_latency NUMERIC  -- Maximum data transfer latency of the distribution en ms, i.e. the delay of data transfer ,
    data_transfer_minimum_throughput NUMERIC  -- Maximum throughput of the distribution in Mbps,
    geo_location VARCHAR(255)  -- Physical location of the data expressed using ISO 3166-1 country code.,
    protocol VARCHAR(255)  -- The protocol used to interact with the host,
    content_type TEXT  -- Content type of the online service (e.g., Web Service, Dataset, API, Application, Supporting Document),
    format VARCHAR(255)  -- Format of the online service,
    language TEXT  -- Display language of the online service,
    type VARCHAR(255)  -- The type of system hosting the distribution,
    version TEXT  -- Version number of the host system, if applicable. This field is relevant for software-based hosts such as repositories (e.g., Zenodo 4.0, Dataverse 5.13) or storage systems (e.g., MinIO RELEASE.2024-0
);

-- Table: dmp_dataset_distribution_online_service
-- Description: To list online services where the distribution can be accessed
-- Path: dmp/dataset/distribution/online_service
CREATE TABLE dmp_dataset_distribution_online_service (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_distribution,
    array_index INTEGER  -- Position in the array,
    protocol VARCHAR(255)  -- Protocol of the online service,
    service_language TEXT  -- Language used for the online service,
    service_url TEXT  -- A url that leads to the online service page,
    name TEXT  -- Name of the online service,
    content_type TEXT  -- Content type of the online service,
    format TEXT  -- Format of the online service,
    language TEXT  -- Display language of the online service
);

-- Table: dmp_dataset_distribution_physical_data_asset
-- Description: Allows for recording of physical assets (e.g., external hard drives) and/or physical location of servers, data centers, etc.
-- Path: dmp/dataset/distribution/physical_data_asset
CREATE TABLE dmp_dataset_distribution_physical_data_asset (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_distribution,
    array_index INTEGER  -- Position in the array,
    description TEXT  -- Description of the physical data asset''s appearance, functionality, contents, notable features, etc.,
    type TEXT  -- Physical object type the data is stored on (e.g., blue-ray, clay tablet, compact disk, dvd, hard drive, solid state drive, paper, parchment, stone, quipu, tape, thumb drive),
    building_city TEXT  -- City name where the physical asset(s) are located,
    building_name TEXT  -- Building name where the physical asset(s) are located,
    building_room_number TEXT  -- Room number where the physical asset(s) are located,
    name TEXT  -- Full device name in System where the physical asset(s) are located
);

-- Table: dmp_dataset_distribution_version_history
-- Description: Version history of the data distribution
-- Path: dmp/dataset/distribution/version_history
CREATE TABLE dmp_dataset_distribution_version_history (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_distribution_id INTEGER  -- Foreign key to dmp_dataset_distribution,
    revision_date DATE  -- To indicate the date a revision of the data in the distribution was made. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    revision_description TEXT  -- Description about what changes this revision made,
    revision_documentation TEXT  -- Link to the revision documentation
);

-- Table: dmp_dataset_intellectual_property
-- Description: Intellectual property related to the dataset
-- Path: dmp/dataset/intellectual_property
CREATE TABLE dmp_dataset_intellectual_property (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER  -- Foreign key to dmp_dataset,
    copyright_description TEXT  -- Description of the copyright associated with dataset,
    copyright_extent TEXT  -- Limitations of the copyright associated with the dataset (e.g., all of the dataset; part of the dataset; etc.),
    copyright_holder VARCHAR(255)  -- Main copyright holder ,
    other TEXT  -- To allow for the recording of other rights than copyright.
);

-- Table: dmp_dataset_metadata
-- Description: To describe metadata standards used.
-- Path: dmp/dataset/metadata
CREATE TABLE dmp_dataset_metadata (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    description TEXT  -- To provide any details on the choice of the metadata standard,
    language VARCHAR(255)  -- Language of the metadata expressed using ISO 639-3 (three letter language code)
);

-- Table: dmp_dataset_metadata_metadata_standard_id
-- Description: Identifier associated with the metadata standard. Example: http://www.dublincore.org/specifications/dublin-core/dcmi-terms/
-- Path: dmp/dataset/metadata/metadata_standard_id
CREATE TABLE dmp_dataset_metadata_metadata_standard_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_metadata_id INTEGER  -- Foreign key to dmp_dataset_metadata,
    type VARCHAR(255)  -- To specify what type the ID of the metadata standard is.,
    registry_url TEXT  -- Link to the reference used to identify the metadata standard ,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    identifier TEXT  -- To indicate the specific value of the metadata standard ID 
);

-- Table: dmp_dataset_security_and_privacy
-- Description: To list all security and privacy measures applied to a dataset to protect sensitive information, for example encryption, anonymization, data masking, and compliance with data protection regulations (e
-- Path: dmp/dataset/security_and_privacy
CREATE TABLE dmp_dataset_security_and_privacy (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    title TEXT  -- Provide a title for each requirement or issue listed in the security and privacy section. Titles need to be specific enough to differentiate issues or requirements between them.,
    description TEXT  -- Description of security or privacy controls
);

-- Table: dmp_dataset_security_and_privacy_privacy_impact_assessment
-- Description: Privacy impact assessment related to the dataset. Government of Canada institutions should refer to <a href="https://www.tbs-sct.canada.ca/pol/doc-eng.aspx?id=18309">www.tbs-sct.canada.ca</a> 
-- Path: dmp/dataset/security_and_privacy/privacy_impact_assessment
CREATE TABLE dmp_dataset_security_and_privacy_privacy_impact_assessment (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_security_and_privacy_id INTEGER  -- Foreign key to dmp_dataset_security_and_privacy,
    download_url TEXT  -- A URL that gives access to the privacy impact assessment. The access URL should be used for the URL of a service or location that can provide access to privacy impact assessment, typically through a W,
    required VARCHAR(255)  -- To indicate if a privacy impact assessment is required.
);

-- Table: dmp_dataset_subject
-- Description: Topic to which a dataset pertains.
-- Path: dmp/dataset/subject
CREATE TABLE dmp_dataset_subject (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    heading_name TEXT  -- Subject, classification code, or keyword describing the dataset. Privilege subject headings from controlled vocabularies (subject schemes).,
    heading_uri TEXT  -- The URI of the subject heading value.,
    scheme_name TEXT  -- To indicate the name of the subject scheme or classification system from which the subject heading or classification code is drawn (e.g., Government of Canada Core Subject Thesaurus Government of Cana,
    scheme_uri TEXT  -- The URI of the subject scheme. Consider URIs available at <a href="https://id.loc.gov/vocabulary/subjectSchemes.html">id.loc.gov</a>,
    scheme_version TEXT  -- Specify the language and/or iteration number of the subject scheme that was used to assign the subject heading.
);

-- Table: dmp_dataset_technical_resource
-- Path: dmp/dataset/technical_resource
CREATE TABLE dmp_dataset_technical_resource (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_id INTEGER NOT NULL  -- Foreign key to dmp_dataset,
    array_index INTEGER  -- Position in the array,
    name TEXT  -- Name of the technical resource,
    description TEXT  -- List all technical resources (e.g. tools or software) and computing environments required for any stage of a dataset lifecycle (e.g. microscopes, sensors, Jupyter Notebook, Galaxy workflows, measuring
);

-- Table: dmp_dataset_technical_resource_data_management_system
-- Description: To describe the database management system or other computerized data system used to store or manage active data. Every other systems used to access the data should be described as distributions.
-- Path: dmp/dataset/technical_resource/data_management_system
CREATE TABLE dmp_dataset_technical_resource_data_management_system (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_technical_resource_id INTEGER  -- Foreign key to dmp_dataset_technical_resource,
    description TEXT  -- Brief explanation of the system’s purpose and functionality in relation to this dataset. If relevant, indicate the data types managed by the system.,
    pid_system VARCHAR(255)  -- Persistent identifier system used by the system.,
    support_checksum VARCHAR(255)  -- Indicates whether checksum verification is supported,
    support_versioning VARCHAR(255)  -- To indicate if the data management system supports versioning, meaning changes to datasets are tracked internally,
    availability TEXT  -- Defines whether the system is operational 24/7 or has downtime periods (e.g., 24/7, scheduled downtime),
    backup_frequency TEXT  -- Backup frequency of the system,
    backup_type VARCHAR(255)  -- Type of backup performed on the data (e.g., incremental, full, differential, synthetic full),
    certified_with TEXT  -- Certifications relevant to the system (e.g., CoreTrustSeal, ISO 16363).,
    geo_location VARCHAR(255)  -- The geographical location of the server hosting the system expressed using ISO 3166-1 country code.,
    protocol VARCHAR(255)  -- The protocol used to interact with the system ,
    access_url TEXT  -- Web or network-accessible URL for accessing the system,
    authentication VARCHAR(255)  -- User access and authentication mechanisms. ,
    visibility VARCHAR(255)  -- Defines whether the data management system is accessible internally within an organization or externally to broader audiences. Allowed values: Internal (accessible only within a specific organization ,
    version TEXT  -- Version of the data management system,
    type VARCHAR(255)  -- The type of system used to store and manage active data. Note that a time-series database like TimescaleDB is actually a relational database, but because it''s optimized for time-series data, it gets ,
    title TEXT  -- Name of the active data management system used to store/process data (e.g., PostgreSQL, MySQL, Dataverse, iRODS, etc.),
    storage_type VARCHAR(255)  -- Type or types of storage used by the data management system,
    compliance_standards TEXT  -- Standards the system follows for security, data management, and governance (e.g., GDPR, HIPAA, SOC 2 compliance),
    data_transfer_maximum_latency NUMERIC  -- Maximum data transfer latency of the data en ms, i.e. the delay of data transfer ,
    data_transfer_minimum_throughput NUMERIC  -- Maximum throughput of the dataset in Mbps
);

-- Table: dmp_dataset_technical_resource_hardware_requirements
-- Description: Minimum requirements for processing data for a specific purpose
-- Path: dmp/dataset/technical_resource/hardware_requirements
CREATE TABLE dmp_dataset_technical_resource_hardware_requirements (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_technical_resource_id INTEGER  -- Foreign key to dmp_dataset_technical_resource,
    minimum_cpu_cores NUMERIC  -- Minimum CPU cores needed to process the data,
    minimum_cpu_speed NUMERIC  -- Minimum clock speed needed to process the data in GHz,
    machine_type TEXT  -- Minimum computing type needed to process the data (e.g., desktop workstation, laptop, server, HPC, super computer),
    data_processing_minimum_ram_gb NUMERIC  -- Minimum RAM needed to process the data in GB,
    processing_unit_requirements TEXT  -- Need for specialized hardware like GPUs/TPUs for computation,
    storage_capacity NUMERIC  -- Minimum storage space required,
    description TEXT  -- Describe the hardware requirement,
    network_requirements NUMERIC  -- Minimum bandwidth or network speed required in Mbps,
    title TEXT  -- Identify the purpose requiring specific hardware
);

-- Table: dmp_dataset_technical_resource_software
-- Description: Repeat as many times as needed to describe all software and code used for data collection, data processing, data analysis, data dissemination. Fill in the computer code or the software section. If app
-- Path: dmp/dataset/technical_resource/software
CREATE TABLE dmp_dataset_technical_resource_software (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_technical_resource_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_technical_resource,
    array_index INTEGER  -- Position in the array,
    description TEXT  -- To provide any free-form text information on the computer code used,
    download_url TEXT  -- the URL to download the computer code or the software,
    license TEXT  -- The licensing terms under which the software/code is released. Use of a license is highly recommended (e.g., CC BY-SA 4.0, MIT, open government license, etc.),
    programming_language TEXT  -- Computer programming language used (e.g., Python, R, SAS),
    proprietary_software VARCHAR(255)  -- To indicate if proprietary software was used,
    operating_system_name VARCHAR(255)  -- If OS dependent, operating system used ,
    operating_system_description TEXT  -- If OS dependent, to provide any free-form text information on the operating system used,
    code_repository TEXT  -- Link to a version control repository if applicable,
    execution_environment TEXT  -- Specify where the software runs (e.g., Local Machine, Cloud, Docker, Kubernetes, etc.),
    dependencies TEXT  -- Any additional libraries required for execution (e.g., NumPy, TensorFlow, Pandas, etc.)
);

-- Table: dmp_dataset_technical_resource_software_software_management_pla
-- Description: To reference an external software management plan
-- Path: dmp/dataset/technical_resource/software/software_management_plan
CREATE TABLE dmp_dataset_technical_resource_software_software_management_pla (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_dataset_technical_resource_software_id INTEGER NOT NULL  -- Foreign key to dmp_dataset_technical_resource_software,
    array_index INTEGER  -- Position in the array,
    name TEXT,
    access_url TEXT  -- A URL of that gives access to the Software Management Plan (SMP), e.g., landing page, feed, SPARQL endpoint. The access URL should be used for the URL of a service or location that can provide access ,
    download_url TEXT  -- Title of the external document documenting the  cost
);

-- Table: dmp_general_info
-- Path: dmp/general_info
CREATE TABLE dmp_general_info (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER  -- Foreign key to dmp,
    title TEXT  -- Title of the DMP,
    description TEXT  -- To provide any free-form text information on the Data Management Plan (maDMP). It can be a formal statement describing how research data will be managed and documented throughout a research project an,
    created TIMESTAMP  -- Date and time of the first version of the maDMP. This date must not be changed in subsequent maDMPs. Each maDMP has a "Created" date and a "Modified" date. The modification date contains a timestamp o,
    modified TIMESTAMP  -- Indicates maDMP version, so must be set each time the maDMP is modified.  Dates can be used to indicate past and planned actions. Dataset contains issue date that indicates whether the actions are pla,
    language VARCHAR(255)  -- Language of the DMP expressed using ISO 639-3,
    access VARCHAR(255)  -- OPEN ACCESS: available to anyone based on an open license (e.g., CC0, CC-BY, Open Government License). SHARED ACCESS: Public access with a license that limits use, that is available to anyone under te,
    protection_level VARCHAR(255)  -- Protected information is not classified. Information is "protected" when unauthorized disclosure could reasonably be expected to cause injury to a non-national interest (i.e., an individual interest s,
    protection_level_other_nomenclature TEXT  -- To indicate the protection level of the dmp according to the nomenclature found in dmp_protection_level_other_nomenclature,
    protection_level_other_level TEXT  -- To indicate which nomenclature is used to qualify the dmp protection level when "other" was chosen in dmp_protection_level,
    security_classification_level VARCHAR(255)  -- Security classification that designates the level of protection against access the DMP requires when unauthorized disclosure could reasonably be expected to cause injury to the national interest – def,
    security_classification_level_other_nomenclature TEXT  -- To indicate the level of the classified information held by the dmp according to the nomenclature found in dmp_security_classification_level_other_nomenclature,
    security_classification_level_other_level TEXT  -- To indicate which nomenclature is used to qualify classified information,
    schema_version TEXT  -- The version you are using is vnan, you should not edit this field.,
    schema_version_uri TEXT  -- DMP schema URI ,
    ethical_issues_exist VARCHAR(255)  -- To indicate whether there are ethical issues related to these data. It is the responsibility of the researcher or data steward to be aware of any ethical issues related to the data. Ethical issues var,
    ethical_issues_description TEXT  -- To describe any existing or potential ethical issues that are not captured in the following related fields: dmp/protection_level, dmp/security_classification_level, dmp/dataset/disposition_planning/le,
    ethical_issues_report TEXT  -- To indicate, for example, where a protocol from a meeting with an ethical committee can be found, or an IRB (Institutional Review Board) report.
);

-- Table: dmp_general_info_dmp_id
-- Description: Identifier for the DMP itself
-- Path: dmp/general_info/dmp_id
CREATE TABLE dmp_general_info_dmp_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_general_info_id INTEGER  -- Foreign key to dmp_general_info,
    type VARCHAR(255)  -- To specify what type the DMP ID is.,
    registry_uri TEXT  -- Link to the registry or system used to identify the linked dmp,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    identifier TEXT  -- To indicate the specific value of the DMP ID
);

-- Table: dmp_general_info_linked_dmp
-- Description: to link related dmps , for example official-language-equivalent dmps
-- Path: dmp/general_info/linked_dmp
CREATE TABLE dmp_general_info_linked_dmp (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_general_info_id INTEGER NOT NULL  -- Foreign key to dmp_general_info,
    array_index INTEGER  -- Position in the array,
    relationship TEXT  -- Explain the relationship of the linked dmp with respect to this dmp. Specify which version is authoritative, if applicable. Example: the linked dmp is the working French version of this authoritative ,
    access_url TEXT  -- URL where the linked dmp can be accessed,
    download_url TEXT  -- URL where the linked dmp can be downloaded
);

-- Table: dmp_general_info_linked_dmp_linked_dmp_id
-- Description: identifier of the related dmp
-- Path: dmp/general_info/linked_dmp/linked_dmp_id
CREATE TABLE dmp_general_info_linked_dmp_linked_dmp_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_general_info_linked_dmp_id INTEGER NOT NULL  -- Foreign key to dmp_general_info_linked_dmp,
    array_index INTEGER  -- Position in the array,
    type VARCHAR(255)  -- type of identifier,
    registry_uri TEXT  -- Link to the reference used to identify the linked dmp,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    identifier TEXT  -- identifier of the related dmp
);

-- Table: dmp_indigenous_considerations
-- Description: Indigenous considerations related to the maDMP or the data.
-- Path: dmp/indigenous_considerations
CREATE TABLE dmp_indigenous_considerations (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER  -- Foreign key to dmp,
    exist VARCHAR(255)  -- To indicate if Indigenous consideration exist.,
    group_identification TEXT  -- To indicate which Indigenous group(s) this dataset is related to. For example, in Canada (Indian Band, Inuit, Metis), in Europe (Sami), in New Zealand (Maori), or self-identification. ,
    government_name TEXT  -- Indigenous government group affiliated with the contributor,
    language VARCHAR(255)  -- To indicate if Indigenous language is used. If the answer is "yes," then it is identified under maDMP language and/or Dataset language and/or Distribution language.,
    characters VARCHAR(255)  -- To indicate if Indigenous characters are used in the data. If the answer is "yes," then ''Unified Canadian Aboriginal Syllabics Extended'' is identified under distribution/character_unicode_block,
    research_method TEXT  -- To record research methods that have particular significance to an Indigenous community, or that are considered by the researchers to be Indigenous research methods. Examples might include dadirri (au,
    indian_band_name VARCHAR(255)  -- First Nations Indian Band name corresponding to the First Nations code associated with the dataset. <a href="https://fnp-ppn.aadnc-aandc.gc.ca/fnp/Main/Search/SearchFN.aspx?lang=eng">fnp-ppn.aadnc-aan,
    indian_band_number VARCHAR(255)  -- First Nations Indian band number associated with the dataset. <a href="https://fnp-ppn.aadnc-aandc.gc.ca/fnp/Main/Search/SearchFN.aspx?lang=eng">fnp-ppn.aadnc-aandc.gc.ca</a> ; 
<a href="https://open.
);

-- Table: dmp_indigenous_considerations_community_approval
-- Description: to describe approvals by indigenous communities
-- Path: dmp/indigenous_considerations/community_approval
CREATE TABLE dmp_indigenous_considerations_community_approval (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_indigenous_considerations_id INTEGER NOT NULL  -- Foreign key to dmp_indigenous_considerations,
    array_index INTEGER  -- Position in the array,
    status TEXT  -- To provide any free-form text information on the project approval from the Indigenous communities.
);

-- Table: dmp_project
-- Description: Project(s) related to the DMP
-- Path: dmp/project
CREATE TABLE dmp_project (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_id INTEGER NOT NULL  -- Foreign key to dmp,
    array_index INTEGER  -- Position in the array,
    title TEXT  -- Project title,
    description TEXT  -- Project abstract providing an overview of the project''s goals and scope,
    start DATE  -- Project start date. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    end DATE  -- Project end date. Encoded using the relevant ISO 8601 Date <a href="https://www.w3.org/TR/NOTE-datetime">compliant string</a>,
    succession_plan TEXT  -- Succession plan, or business continuity plan,
    algorithmic_impact_assessment_conducted VARCHAR(255)  -- To indicate if an algorithmic impact assessment has been conducted related to these data. For example using this <a href="https://www.canada.ca/en/government/system/digital-government/digital-governme,
    algorithmic_impact_assessment_conducted_url TEXT  -- Link to the algorithmic impact assessment,
    classification_plan_code TEXT  -- To indicate the code that applies to the project documents in the organization''s classification plan or file plan (recordkeeping).
);

-- Table: dmp_project_funding
-- Description: Funding related with a project
-- Path: dmp/project/funding
CREATE TABLE dmp_project_funding (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_id INTEGER NOT NULL  -- Foreign key to dmp_project,
    array_index INTEGER  -- Position in the array,
    funding_status VARCHAR(255)  -- To express different phases of project lifecycle.
);

-- Table: dmp_project_funding_funder_id
-- Description: Identifier associated with the project funder
-- Path: dmp/project/funding/funder_id
CREATE TABLE dmp_project_funding_funder_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_funding_id INTEGER  -- Foreign key to dmp_project_funding,
    type VARCHAR(255)  -- To specify what type the funder identifier is.,
    registry_uri TEXT  -- Link to the registry or system used to identify the funder,
    registry_version TEXT  -- To indicate the version number or date when the registry or reference was consulted,
    identifier TEXT  -- To indicate the specific value of the funder’s identifier. It is recommended to use <a href="https://www.crossref.org/services/funder-registry/" target="_blank">CrossRef Funder Registry</a>.
);

-- Table: dmp_project_funding_grant_id
-- Description: Identifier associated with the grant
-- Path: dmp/project/funding/grant_id
CREATE TABLE dmp_project_funding_grant_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_funding_id INTEGER  -- Foreign key to dmp_project_funding,
    type VARCHAR(255)  -- To specify what type the grant ID is.,
    registry_uri TEXT  -- Link to the reference used to identify the grant,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    identifier TEXT  -- To indicate the specific value of the grant ID.
);

-- Table: dmp_project_funding_source
-- Description: Project funding source
-- Path: dmp/project/funding/source
CREATE TABLE dmp_project_funding_source (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_funding_id INTEGER NOT NULL  -- Foreign key to dmp_project_funding,
    array_index INTEGER  -- Position in the array,
    type TEXT  -- Funding source type for the project (e.g., OCIO A-base, OCIO B-base, program A-base, program B-base, Treasury Board submission, vote-net revenue (VNR), no funding),
    description TEXT  -- To provide any free-form text information on the funding source for the project
);

-- Table: dmp_project_partner_organization
-- Description: Partner organization
-- Path: dmp/project/partner_organization
CREATE TABLE dmp_project_partner_organization (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_id INTEGER NOT NULL  -- Foreign key to dmp_project,
    array_index INTEGER  -- Position in the array,
    name TEXT  -- Name of partner organization.
);

-- Table: dmp_project_partner_organization_agreement
-- Description: Partner organization agreement
-- Path: dmp/project/partner_organization/agreement
CREATE TABLE dmp_project_partner_organization_agreement (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_partner_organization_id INTEGER  -- Foreign key to dmp_project_partner_organization,
    description TEXT  -- To provide any free-form text information description on the agreement made with the partner organization,
    type TEXT  -- Partner organization agreement type (e.g., MOA - Memorandum of Agreement; MOU - Memorandum of Understanding; Indigenous data sharing agreement; BCR-band council resolution; Treaty; collaborative agree,
    agreement_download_url TEXT  -- Download link to the partner organization agreement document 
);

-- Table: dmp_project_partner_organization_partner_organization_id
-- Description: Unique identifier assigned to represent partner organization.
-- Path: dmp/project/partner_organization/partner_organization_id
CREATE TABLE dmp_project_partner_organization_partner_organization_id (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_partner_organization_id INTEGER  -- Foreign key to dmp_project_partner_organization,
    type TEXT  -- Partner organization identifier type,
    registry_uri TEXT  -- Link to the reference used to identify the partner organization,
    registry_version TEXT  -- To indicate the version number or date of the reference,
    identifier TEXT  -- Partner organization identifier
);

-- Table: dmp_project_safeguarding_science_measures
-- Description: Science is defined broadly to include the natural, health, and social sciences, mathematics, engineering, and technology. Safeguarding science includes safeguarding research partnerships, opensource d
-- Path: dmp/project/safeguarding_science_measures
CREATE TABLE dmp_project_safeguarding_science_measures (
    id SERIAL PRIMARY KEY  -- Auto-generated primary key,
    dmp_project_id INTEGER  -- Foreign key to dmp_project,
    exist VARCHAR(255)  -- To indicate if any measure has have been taken to safeguard the project,
    redundant_backups_exist VARCHAR(255)  -- To indicate if any redundant backup of the source data exists
);

-- Foreign Key Constraints

ALTER TABLE dmp_general_info ADD CONSTRAINT fk_dmp_general_info_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_general_info_dmp_id ADD CONSTRAINT fk_dmp_general_info_dmp_id_dmp_general_info_id FOREIGN KEY (dmp_general_info_id) REFERENCES dmp_general_info(id) ON DELETE CASCADE;
ALTER TABLE dmp_general_info_linked_dmp ADD CONSTRAINT fk_dmp_general_info_linked_dmp_dmp_general_info_id FOREIGN KEY (dmp_general_info_id) REFERENCES dmp_general_info(id) ON DELETE CASCADE;
ALTER TABLE dmp_general_info_linked_dmp_linked_dmp_id ADD CONSTRAINT fk_dmp_general_info_linked_dmp_linked_dmp_id_dmp_general_info_linked_dmp_id FOREIGN KEY (dmp_general_info_linked_dmp_id) REFERENCES dmp_general_info_linked_dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_contributor ADD CONSTRAINT fk_dmp_contributor_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_contributor_contributor_id ADD CONSTRAINT fk_dmp_contributor_contributor_id_dmp_contributor_id FOREIGN KEY (dmp_contributor_id) REFERENCES dmp_contributor(id) ON DELETE CASCADE;
ALTER TABLE dmp_contributor_affiliation ADD CONSTRAINT fk_dmp_contributor_affiliation_dmp_contributor_id FOREIGN KEY (dmp_contributor_id) REFERENCES dmp_contributor(id) ON DELETE CASCADE;
ALTER TABLE dmp_contributor_affiliation_contributor_affiliation_id ADD CONSTRAINT fk_dmp_contributor_affiliation_contributor_affiliation_id_dmp_contributor_affiliation_id FOREIGN KEY (dmp_contributor_affiliation_id) REFERENCES dmp_contributor_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_contributor_affiliation_contributor_country ADD CONSTRAINT fk_dmp_contributor_affiliation_contributor_country_dmp_contributor_affiliation_id FOREIGN KEY (dmp_contributor_affiliation_id) REFERENCES dmp_contributor_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_contributor_affiliation_contributor_province_state ADD CONSTRAINT fk_dmp_contributor_affiliation_contributor_province_state_dmp_contributor_affiliation_id FOREIGN KEY (dmp_contributor_affiliation_id) REFERENCES dmp_contributor_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_approval ADD CONSTRAINT fk_dmp_approval_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_project ADD CONSTRAINT fk_dmp_project_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_funding ADD CONSTRAINT fk_dmp_project_funding_dmp_project_id FOREIGN KEY (dmp_project_id) REFERENCES dmp_project(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_funding_source ADD CONSTRAINT fk_dmp_project_funding_source_dmp_project_funding_id FOREIGN KEY (dmp_project_funding_id) REFERENCES dmp_project_funding(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_funding_funder_id ADD CONSTRAINT fk_dmp_project_funding_funder_id_dmp_project_funding_id FOREIGN KEY (dmp_project_funding_id) REFERENCES dmp_project_funding(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_funding_grant_id ADD CONSTRAINT fk_dmp_project_funding_grant_id_dmp_project_funding_id FOREIGN KEY (dmp_project_funding_id) REFERENCES dmp_project_funding(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_partner_organization ADD CONSTRAINT fk_dmp_project_partner_organization_dmp_project_id FOREIGN KEY (dmp_project_id) REFERENCES dmp_project(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_partner_organization_agreement ADD CONSTRAINT fk_dmp_project_partner_organization_agreement_dmp_project_partner_organization_id FOREIGN KEY (dmp_project_partner_organization_id) REFERENCES dmp_project_partner_organization(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_partner_organization_partner_organization_id ADD CONSTRAINT fk_dmp_project_partner_organization_partner_organization_id_dmp_project_partner_organization_id FOREIGN KEY (dmp_project_partner_organization_id) REFERENCES dmp_project_partner_organization(id) ON DELETE CASCADE;
ALTER TABLE dmp_project_safeguarding_science_measures ADD CONSTRAINT fk_dmp_project_safeguarding_science_measures_dmp_project_id FOREIGN KEY (dmp_project_id) REFERENCES dmp_project(id) ON DELETE CASCADE;
ALTER TABLE dmp_cost ADD CONSTRAINT fk_dmp_cost_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_cost_cost_documentation ADD CONSTRAINT fk_dmp_cost_cost_documentation_dmp_cost_id FOREIGN KEY (dmp_cost_id) REFERENCES dmp_cost(id) ON DELETE CASCADE;
ALTER TABLE dmp_indigenous_considerations ADD CONSTRAINT fk_dmp_indigenous_considerations_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_indigenous_considerations_community_approval ADD CONSTRAINT fk_dmp_indigenous_considerations_community_approval_dmp_indigenous_considerations_id FOREIGN KEY (dmp_indigenous_considerations_id) REFERENCES dmp_indigenous_considerations(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset ADD CONSTRAINT fk_dmp_dataset_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_dataset_id ADD CONSTRAINT fk_dmp_dataset_dataset_id_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_subject ADD CONSTRAINT fk_dmp_dataset_subject_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_dataset_documentation ADD CONSTRAINT fk_dmp_dataset_dataset_documentation_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_security_and_privacy ADD CONSTRAINT fk_dmp_dataset_security_and_privacy_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_security_and_privacy_privacy_impact_assessment ADD CONSTRAINT fk_dmp_dataset_security_and_privacy_privacy_impact_assessment_dmp_dataset_security_and_privacy_id FOREIGN KEY (dmp_dataset_security_and_privacy_id) REFERENCES dmp_dataset_security_and_privacy(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_collection ADD CONSTRAINT fk_dmp_dataset_collection_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_technical_resource ADD CONSTRAINT fk_dmp_dataset_technical_resource_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_technical_resource_data_management_system ADD CONSTRAINT fk_dmp_dataset_technical_resource_data_management_system_dmp_dataset_technical_resource_id FOREIGN KEY (dmp_dataset_technical_resource_id) REFERENCES dmp_dataset_technical_resource(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_technical_resource_hardware_requirements ADD CONSTRAINT fk_dmp_dataset_technical_resource_hardware_requirements_dmp_dataset_technical_resource_id FOREIGN KEY (dmp_dataset_technical_resource_id) REFERENCES dmp_dataset_technical_resource(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_technical_resource_software ADD CONSTRAINT fk_dmp_dataset_technical_resource_software_dmp_dataset_technical_resource_id FOREIGN KEY (dmp_dataset_technical_resource_id) REFERENCES dmp_dataset_technical_resource(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_technical_resource_software_software_management_pla ADD CONSTRAINT fk_dmp_dataset_technical_resource_software_software_management_pla_dmp_dataset_technical_resource_software_id FOREIGN KEY (dmp_dataset_technical_resource_software_id) REFERENCES dmp_dataset_technical_resource_software(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_intellectual_property ADD CONSTRAINT fk_dmp_dataset_intellectual_property_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_metadata ADD CONSTRAINT fk_dmp_dataset_metadata_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_metadata_metadata_standard_id ADD CONSTRAINT fk_dmp_dataset_metadata_metadata_standard_id_dmp_dataset_metadata_id FOREIGN KEY (dmp_dataset_metadata_id) REFERENCES dmp_dataset_metadata(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution ADD CONSTRAINT fk_dmp_dataset_distribution_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_version_history ADD CONSTRAINT fk_dmp_dataset_distribution_version_history_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_geographic_bounding_box ADD CONSTRAINT fk_dmp_dataset_distribution_geographic_bounding_box_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_host ADD CONSTRAINT fk_dmp_dataset_distribution_host_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_physical_data_asset ADD CONSTRAINT fk_dmp_dataset_distribution_physical_data_asset_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_distribution_id ADD CONSTRAINT fk_dmp_dataset_distribution_distribution_id_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_online_service ADD CONSTRAINT fk_dmp_dataset_distribution_online_service_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_distribution_data_integrity ADD CONSTRAINT fk_dmp_dataset_distribution_data_integrity_dmp_dataset_distribution_id FOREIGN KEY (dmp_dataset_distribution_id) REFERENCES dmp_dataset_distribution(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_disposition_planning ADD CONSTRAINT fk_dmp_dataset_disposition_planning_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_disposition_planning_retention_specification ADD CONSTRAINT fk_dmp_dataset_disposition_planning_retention_specification_dmp_dataset_disposition_planning_id FOREIGN KEY (dmp_dataset_disposition_planning_id) REFERENCES dmp_dataset_disposition_planning(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_disposition_planning_disposition_impediment ADD CONSTRAINT fk_dmp_dataset_disposition_planning_disposition_impediment_dmp_dataset_disposition_planning_id FOREIGN KEY (dmp_dataset_disposition_planning_id) REFERENCES dmp_dataset_disposition_planning(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_disposition_action ADD CONSTRAINT fk_dmp_dataset_disposition_action_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_creator ADD CONSTRAINT fk_dmp_dataset_creator_dmp_dataset_id FOREIGN KEY (dmp_dataset_id) REFERENCES dmp_dataset(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_creator_affiliation ADD CONSTRAINT fk_dmp_dataset_creator_affiliation_dmp_dataset_creator_id FOREIGN KEY (dmp_dataset_creator_id) REFERENCES dmp_dataset_creator(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_creator_affiliation_creator_affiliation_id ADD CONSTRAINT fk_dmp_dataset_creator_affiliation_creator_affiliation_id_dmp_dataset_creator_affiliation_id FOREIGN KEY (dmp_dataset_creator_affiliation_id) REFERENCES dmp_dataset_creator_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_creator_affiliation_creator_country ADD CONSTRAINT fk_dmp_dataset_creator_affiliation_creator_country_dmp_dataset_creator_affiliation_id FOREIGN KEY (dmp_dataset_creator_affiliation_id) REFERENCES dmp_dataset_creator_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_creator_affiliation_creator_province_state ADD CONSTRAINT fk_dmp_dataset_creator_affiliation_creator_province_state_dmp_dataset_creator_affiliation_id FOREIGN KEY (dmp_dataset_creator_affiliation_id) REFERENCES dmp_dataset_creator_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_dataset_creator_creator_id ADD CONSTRAINT fk_dmp_dataset_creator_creator_id_dmp_dataset_creator_id FOREIGN KEY (dmp_dataset_creator_id) REFERENCES dmp_dataset_creator(id) ON DELETE CASCADE;
ALTER TABLE dmp_contact ADD CONSTRAINT fk_dmp_contact_dmp_id FOREIGN KEY (dmp_id) REFERENCES dmp(id) ON DELETE CASCADE;
ALTER TABLE dmp_contact_contact_id ADD CONSTRAINT fk_dmp_contact_contact_id_dmp_contact_id FOREIGN KEY (dmp_contact_id) REFERENCES dmp_contact(id) ON DELETE CASCADE;
ALTER TABLE dmp_contact_affiliation ADD CONSTRAINT fk_dmp_contact_affiliation_dmp_contact_id FOREIGN KEY (dmp_contact_id) REFERENCES dmp_contact(id) ON DELETE CASCADE;
ALTER TABLE dmp_contact_affiliation_contact_affiliation_id ADD CONSTRAINT fk_dmp_contact_affiliation_contact_affiliation_id_dmp_contact_affiliation_id FOREIGN KEY (dmp_contact_affiliation_id) REFERENCES dmp_contact_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_contact_affiliation_contact_country ADD CONSTRAINT fk_dmp_contact_affiliation_contact_country_dmp_contact_affiliation_id FOREIGN KEY (dmp_contact_affiliation_id) REFERENCES dmp_contact_affiliation(id) ON DELETE CASCADE;
ALTER TABLE dmp_contact_affiliation_contact_province_state ADD CONSTRAINT fk_dmp_contact_affiliation_contact_province_state_dmp_contact_affiliation_id FOREIGN KEY (dmp_contact_affiliation_id) REFERENCES dmp_contact_affiliation(id) ON DELETE CASCADE;

-- Indexes for Foreign Keys

CREATE INDEX idx_dmp_general_info_dmp_id ON dmp_general_info(dmp_id);
CREATE INDEX idx_dmp_general_info_dmp_id_dmp_general_info_id ON dmp_general_info_dmp_id(dmp_general_info_id);
CREATE INDEX idx_dmp_general_info_linked_dmp_dmp_general_info_id ON dmp_general_info_linked_dmp(dmp_general_info_id);
CREATE INDEX idx_dmp_general_info_linked_dmp_linked_dmp_id_dmp_general_info_linked_dmp_id ON dmp_general_info_linked_dmp_linked_dmp_id(dmp_general_info_linked_dmp_id);
CREATE INDEX idx_dmp_contributor_dmp_id ON dmp_contributor(dmp_id);
CREATE INDEX idx_dmp_contributor_contributor_id_dmp_contributor_id ON dmp_contributor_contributor_id(dmp_contributor_id);
CREATE INDEX idx_dmp_contributor_affiliation_dmp_contributor_id ON dmp_contributor_affiliation(dmp_contributor_id);
CREATE INDEX idx_dmp_contributor_affiliation_contributor_affiliation_id_dmp_contributor_affiliation_id ON dmp_contributor_affiliation_contributor_affiliation_id(dmp_contributor_affiliation_id);
CREATE INDEX idx_dmp_contributor_affiliation_contributor_country_dmp_contributor_affiliation_id ON dmp_contributor_affiliation_contributor_country(dmp_contributor_affiliation_id);
CREATE INDEX idx_dmp_contributor_affiliation_contributor_province_state_dmp_contributor_affiliation_id ON dmp_contributor_affiliation_contributor_province_state(dmp_contributor_affiliation_id);
CREATE INDEX idx_dmp_approval_dmp_id ON dmp_approval(dmp_id);
CREATE INDEX idx_dmp_project_dmp_id ON dmp_project(dmp_id);
CREATE INDEX idx_dmp_project_funding_dmp_project_id ON dmp_project_funding(dmp_project_id);
CREATE INDEX idx_dmp_project_funding_source_dmp_project_funding_id ON dmp_project_funding_source(dmp_project_funding_id);
CREATE INDEX idx_dmp_project_funding_funder_id_dmp_project_funding_id ON dmp_project_funding_funder_id(dmp_project_funding_id);
CREATE INDEX idx_dmp_project_funding_grant_id_dmp_project_funding_id ON dmp_project_funding_grant_id(dmp_project_funding_id);
CREATE INDEX idx_dmp_project_partner_organization_dmp_project_id ON dmp_project_partner_organization(dmp_project_id);
CREATE INDEX idx_dmp_project_partner_organization_agreement_dmp_project_partner_organization_id ON dmp_project_partner_organization_agreement(dmp_project_partner_organization_id);
CREATE INDEX idx_dmp_project_partner_organization_partner_organization_id_dmp_project_partner_organization_id ON dmp_project_partner_organization_partner_organization_id(dmp_project_partner_organization_id);
CREATE INDEX idx_dmp_project_safeguarding_science_measures_dmp_project_id ON dmp_project_safeguarding_science_measures(dmp_project_id);
CREATE INDEX idx_dmp_cost_dmp_id ON dmp_cost(dmp_id);
CREATE INDEX idx_dmp_cost_cost_documentation_dmp_cost_id ON dmp_cost_cost_documentation(dmp_cost_id);
CREATE INDEX idx_dmp_indigenous_considerations_dmp_id ON dmp_indigenous_considerations(dmp_id);
CREATE INDEX idx_dmp_indigenous_considerations_community_approval_dmp_indigenous_considerations_id ON dmp_indigenous_considerations_community_approval(dmp_indigenous_considerations_id);
CREATE INDEX idx_dmp_dataset_dmp_id ON dmp_dataset(dmp_id);
CREATE INDEX idx_dmp_dataset_dataset_id_dmp_dataset_id ON dmp_dataset_dataset_id(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_subject_dmp_dataset_id ON dmp_dataset_subject(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_dataset_documentation_dmp_dataset_id ON dmp_dataset_dataset_documentation(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_security_and_privacy_dmp_dataset_id ON dmp_dataset_security_and_privacy(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_security_and_privacy_privacy_impact_assessment_dmp_dataset_security_and_privacy_id ON dmp_dataset_security_and_privacy_privacy_impact_assessment(dmp_dataset_security_and_privacy_id);
CREATE INDEX idx_dmp_dataset_collection_dmp_dataset_id ON dmp_dataset_collection(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_technical_resource_dmp_dataset_id ON dmp_dataset_technical_resource(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_technical_resource_data_management_system_dmp_dataset_technical_resource_id ON dmp_dataset_technical_resource_data_management_system(dmp_dataset_technical_resource_id);
CREATE INDEX idx_dmp_dataset_technical_resource_hardware_requirements_dmp_dataset_technical_resource_id ON dmp_dataset_technical_resource_hardware_requirements(dmp_dataset_technical_resource_id);
CREATE INDEX idx_dmp_dataset_technical_resource_software_dmp_dataset_technical_resource_id ON dmp_dataset_technical_resource_software(dmp_dataset_technical_resource_id);
CREATE INDEX idx_dmp_dataset_technical_resource_software_software_management_pla_dmp_dataset_technical_resource_software_id ON dmp_dataset_technical_resource_software_software_management_pla(dmp_dataset_technical_resource_software_id);
CREATE INDEX idx_dmp_dataset_intellectual_property_dmp_dataset_id ON dmp_dataset_intellectual_property(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_metadata_dmp_dataset_id ON dmp_dataset_metadata(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_metadata_metadata_standard_id_dmp_dataset_metadata_id ON dmp_dataset_metadata_metadata_standard_id(dmp_dataset_metadata_id);
CREATE INDEX idx_dmp_dataset_distribution_dmp_dataset_id ON dmp_dataset_distribution(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_distribution_version_history_dmp_dataset_distribution_id ON dmp_dataset_distribution_version_history(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_distribution_geographic_bounding_box_dmp_dataset_distribution_id ON dmp_dataset_distribution_geographic_bounding_box(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_distribution_host_dmp_dataset_distribution_id ON dmp_dataset_distribution_host(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_distribution_physical_data_asset_dmp_dataset_distribution_id ON dmp_dataset_distribution_physical_data_asset(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_distribution_distribution_id_dmp_dataset_distribution_id ON dmp_dataset_distribution_distribution_id(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_distribution_online_service_dmp_dataset_distribution_id ON dmp_dataset_distribution_online_service(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_distribution_data_integrity_dmp_dataset_distribution_id ON dmp_dataset_distribution_data_integrity(dmp_dataset_distribution_id);
CREATE INDEX idx_dmp_dataset_disposition_planning_dmp_dataset_id ON dmp_dataset_disposition_planning(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_disposition_planning_retention_specification_dmp_dataset_disposition_planning_id ON dmp_dataset_disposition_planning_retention_specification(dmp_dataset_disposition_planning_id);
CREATE INDEX idx_dmp_dataset_disposition_planning_disposition_impediment_dmp_dataset_disposition_planning_id ON dmp_dataset_disposition_planning_disposition_impediment(dmp_dataset_disposition_planning_id);
CREATE INDEX idx_dmp_dataset_disposition_action_dmp_dataset_id ON dmp_dataset_disposition_action(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_creator_dmp_dataset_id ON dmp_dataset_creator(dmp_dataset_id);
CREATE INDEX idx_dmp_dataset_creator_affiliation_dmp_dataset_creator_id ON dmp_dataset_creator_affiliation(dmp_dataset_creator_id);
CREATE INDEX idx_dmp_dataset_creator_affiliation_creator_affiliation_id_dmp_dataset_creator_affiliation_id ON dmp_dataset_creator_affiliation_creator_affiliation_id(dmp_dataset_creator_affiliation_id);
CREATE INDEX idx_dmp_dataset_creator_affiliation_creator_country_dmp_dataset_creator_affiliation_id ON dmp_dataset_creator_affiliation_creator_country(dmp_dataset_creator_affiliation_id);
CREATE INDEX idx_dmp_dataset_creator_affiliation_creator_province_state_dmp_dataset_creator_affiliation_id ON dmp_dataset_creator_affiliation_creator_province_state(dmp_dataset_creator_affiliation_id);
CREATE INDEX idx_dmp_dataset_creator_creator_id_dmp_dataset_creator_id ON dmp_dataset_creator_creator_id(dmp_dataset_creator_id);
CREATE INDEX idx_dmp_contact_dmp_id ON dmp_contact(dmp_id);
CREATE INDEX idx_dmp_contact_contact_id_dmp_contact_id ON dmp_contact_contact_id(dmp_contact_id);
CREATE INDEX idx_dmp_contact_affiliation_dmp_contact_id ON dmp_contact_affiliation(dmp_contact_id);
CREATE INDEX idx_dmp_contact_affiliation_contact_affiliation_id_dmp_contact_affiliation_id ON dmp_contact_affiliation_contact_affiliation_id(dmp_contact_affiliation_id);
CREATE INDEX idx_dmp_contact_affiliation_contact_country_dmp_contact_affiliation_id ON dmp_contact_affiliation_contact_country(dmp_contact_affiliation_id);
CREATE INDEX idx_dmp_contact_affiliation_contact_province_state_dmp_contact_affiliation_id ON dmp_contact_affiliation_contact_province_state(dmp_contact_affiliation_id);

-- Table Comments

COMMENT ON TABLE dmp IS 'Root DMP object';
COMMENT ON TABLE dmp_approval IS 'Approval of the maDMP';
COMMENT ON TABLE dmp_contact IS 'Specifies the party which can provide information about the DMP. This is not necessarily the DMP creator, and it can be a person or an organization.';
COMMENT ON TABLE dmp_contact_affiliation IS 'To provide information about the organization the contact is affiliated with';
COMMENT ON TABLE dmp_contact_affiliation_contact_affiliation_id IS 'Details about the organization''s ID';
COMMENT ON TABLE dmp_contact_affiliation_contact_country IS 'Country where the organization the contact is affiliated to, is located';
COMMENT ON TABLE dmp_contact_affiliation_contact_province_state IS 'Province or state of the organization the contact is affiliated to.';
COMMENT ON TABLE dmp_contact_contact_id IS 'Persistent identifier associated with the contact';
COMMENT ON TABLE dmp_contributor IS 'Party involved in the process of data management described by the DMP, or party involved in the creation and management of the DMP itself.';
COMMENT ON TABLE dmp_contributor_affiliation IS 'Provide information about the organization the contributor is affiliated with ';
COMMENT ON TABLE dmp_contributor_affiliation_contributor_affiliation_id IS 'Details about the organization''s ID';
COMMENT ON TABLE dmp_contributor_affiliation_contributor_country IS 'Country where the organization is located';
COMMENT ON TABLE dmp_contributor_affiliation_contributor_province_state IS 'Province or state of the organization the contributor is affiliated with';
COMMENT ON TABLE dmp_contributor_contributor_id IS 'Persistent identifier associated with the contributor';
COMMENT ON TABLE dmp_cost IS 'To list costs related to data management. Providing multiple instances of a ''Cost'' allows to break down costs into details. Providing one ''Cost'' instance allows to provide one aggregated sum.';
COMMENT ON TABLE dmp_cost_cost_documentation IS 'Any external material documenting the costing details.';
COMMENT ON TABLE dmp_dataset IS 'To describe data on a non-technical level.';
COMMENT ON TABLE dmp_dataset_collection IS 'Information on how the data is collected.';
COMMENT ON TABLE dmp_dataset_creator IS 'To specify the creators of the dataset';
COMMENT ON TABLE dmp_dataset_creator_affiliation IS 'To provide information about the organization(s) the creator is affiliated to';
COMMENT ON TABLE dmp_dataset_creator_affiliation_creator_country IS 'Country where the organization the contributor is affiliated to, is located';
COMMENT ON TABLE dmp_dataset_creator_affiliation_creator_province_state IS 'Province or state of the organization the contributor is affiliated to.';
COMMENT ON TABLE dmp_dataset_creator_creator_id IS 'Identifier associated with the creator';
COMMENT ON TABLE dmp_dataset_dataset_documentation IS 'Repeat as many times as needed to list all existing documentation, procedures for data processing, management, analysis and dissemination; for example: code book, contract, data dictionary, data production specification (ISO 19131 compliant), ELN (electronic lab notebook) protocol, QA/QC methods, SOP (standard operating procedure), workflows, etc.  If applicable, create an entry to indicate the classification plan code that applies to the dataset. In that case, enter "classification plan code" as the name and the actual code in the description. Make sure you also provide the related computing environment information in the dedicated section.';
COMMENT ON TABLE dmp_dataset_dataset_id IS 'Identifier associated with the dataset';
COMMENT ON TABLE dmp_dataset_disposition_action IS 'Used to document disposition that has been effected in relation to a dataset. Note: when all data associated with a dataset has been disposed, also indicate this in “dmp/dataset/disposition_completed.” ';
COMMENT ON TABLE dmp_dataset_disposition_planning IS 'Used to document information in anticipation of a future disposition review. 
Note: does not document disposition actions actually effected.';
COMMENT ON TABLE dmp_dataset_disposition_planning_disposition_impediment IS 'For noting time-limited impediments to effecting disposition at the end of the dataset''s retention period. Note: use the retention specification nest to indicate an indefinite retention period or a perpetual use requirement.';
COMMENT ON TABLE dmp_dataset_distribution IS 'To provide technical information on a specific instance of data.';
COMMENT ON TABLE dmp_dataset_distribution_distribution_id IS 'ID for the distribution';
COMMENT ON TABLE dmp_dataset_distribution_geographic_bounding_box IS 'Rectangular spatial extent that encompasses all the geographic locations represented in the data';
COMMENT ON TABLE dmp_dataset_distribution_host IS 'The host is the system where the data are stored and processed. Be sure to also fill in a physical data asset section to indicate in which the data are hosted especially in which country the server is located if they are hosted on a server or in the cloud.';
COMMENT ON TABLE dmp_dataset_distribution_online_service IS 'To list online services where the distribution can be accessed';
COMMENT ON TABLE dmp_dataset_distribution_physical_data_asset IS 'Allows for recording of physical assets (e.g., external hard drives) and/or physical location of servers, data centers, etc.';
COMMENT ON TABLE dmp_dataset_distribution_version_history IS 'Version history of the data distribution';
COMMENT ON TABLE dmp_dataset_intellectual_property IS 'Intellectual property related to the dataset';
COMMENT ON TABLE dmp_dataset_metadata IS 'To describe metadata standards used.';
COMMENT ON TABLE dmp_dataset_metadata_metadata_standard_id IS 'Identifier associated with the metadata standard. Example: http://www.dublincore.org/specifications/dublin-core/dcmi-terms/';
COMMENT ON TABLE dmp_dataset_security_and_privacy IS 'To list all security and privacy measures applied to a dataset to protect sensitive information, for example encryption, anonymization, data masking, and compliance with data protection regulations (e.g. GDPR or HIPAA). It can also be used to express any security measures required for handling the dataset, e.g. only physical access, etc. Create a new entry for each issue or requirement.';
COMMENT ON TABLE dmp_dataset_security_and_privacy_privacy_impact_assessment IS 'Privacy impact assessment related to the dataset. Government of Canada institutions should refer to <a href="https://www.tbs-sct.canada.ca/pol/doc-eng.aspx?id=18309">www.tbs-sct.canada.ca</a> ';
COMMENT ON TABLE dmp_dataset_subject IS 'Topic to which a dataset pertains.';
COMMENT ON TABLE dmp_dataset_technical_resource_data_management_system IS 'To describe the database management system or other computerized data system used to store or manage active data. Every other systems used to access the data should be described as distributions.';
COMMENT ON TABLE dmp_dataset_technical_resource_hardware_requirements IS 'Minimum requirements for processing data for a specific purpose';
COMMENT ON TABLE dmp_dataset_technical_resource_software IS 'Repeat as many times as needed to describe all software and code used for data collection, data processing, data analysis, data dissemination. Fill in the computer code or the software section. If applicable, fill also the proprietary software section and the software management plan section. You may also want to provide information about the workflow documentation in the dedicated section.';
COMMENT ON TABLE dmp_dataset_technical_resource_software_software_management_pla IS 'To reference an external software management plan';
COMMENT ON TABLE dmp_general_info_dmp_id IS 'Identifier for the DMP itself';
COMMENT ON TABLE dmp_general_info_linked_dmp IS 'to link related dmps , for example official-language-equivalent dmps';
COMMENT ON TABLE dmp_general_info_linked_dmp_linked_dmp_id IS 'identifier of the related dmp';
COMMENT ON TABLE dmp_indigenous_considerations IS 'Indigenous considerations related to the maDMP or the data.';
COMMENT ON TABLE dmp_indigenous_considerations_community_approval IS 'to describe approvals by indigenous communities';
COMMENT ON TABLE dmp_project IS 'Project(s) related to the DMP';
COMMENT ON TABLE dmp_project_funding IS 'Funding related with a project';
COMMENT ON TABLE dmp_project_funding_funder_id IS 'Identifier associated with the project funder';
COMMENT ON TABLE dmp_project_funding_grant_id IS 'Identifier associated with the grant';
COMMENT ON TABLE dmp_project_funding_source IS 'Project funding source';
COMMENT ON TABLE dmp_project_partner_organization IS 'Partner organization';
COMMENT ON TABLE dmp_project_partner_organization_agreement IS 'Partner organization agreement';
COMMENT ON TABLE dmp_project_partner_organization_partner_organization_id IS 'Unique identifier assigned to represent partner organization.';
COMMENT ON TABLE dmp_project_safeguarding_science_measures IS 'Science is defined broadly to include the natural, health, and social sciences, mathematics, engineering, and technology. Safeguarding science includes safeguarding research partnerships, opensource due diligence, and risk mitigation. Some elements of safeguarding science are recorded elsewhere in the maDMP (e.g., checksum, data access, data security-privacy measures, ethical issues, intellectual property, partner agreement, protection level, retention/disposition planning, security classification, succession plan, versioning). This section should be used for additional information (e.g., description and link to a risk assessment and mitigation plan). For guidance, see: <a href="https://www.oecd.org/content/dam/oecd/en/publications/reports/2022/06/integrity-and-security-in-the-global-research-ecosystem_2bd8511d/1c416f43-en.pdf">www.oecd.org</a>  ;  <a href="https://science.gc.ca/site/science/en/safeguarding-your-research/guidelines-and-tools-implement-research-security/guidance-conducting-open-source-due-diligence/conducting-open-source-due-diligence-safeguarding-research-partnerships">science.gc.ca</a>  ;  <a href="https://science.gc.ca/site/science/en/safeguarding-your-research/guidelines-and-tools-implement-research-security/mitigating-your-research-security-risks">science.gc.ca</a>  ;  <a href="https://science.gc.ca/site/science/en/safeguarding-your-research/guidelines-and-tools-implement-research-security/national-security-guidelines-research-partnerships/national-security-guidelines-research-partnerships-risk-assessment-form">science.gc.ca</a>';
