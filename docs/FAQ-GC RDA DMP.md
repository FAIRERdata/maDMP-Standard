**FAQ**  
Frequently Asked Questions

## 

[How will the maDMP help me?	1](#how-will-the-madmp-help-me?)

[Where do I deposit my maDMP?	1](#where-do-i-deposit-my-madmp?)

[What happens to the maDMP when a dataset is archived at LAC or destroyed?	1](#what-happens-to-the-madmp-when-a-dataset-is-archived-at-lac-or-destroyed?)

[When to use the maDMP Standard?	1](#when-to-use-the-madmp-standard?)

[Do I need to populate all fields?	1](#do-i-need-to-populate-all-fields?)

[What is the granularity of the maDMP?	2](#what-is-the-granularity-of-the-madmp?)

[What is the difference between a dataset and a distribution?	2](#what-is-the-difference-between-a-dataset-and-a-distribution?)

[How does versioning work?	2](#how-does-versioning-work?)

[How to express that something is planned for the future?	2](#how-to-express-that-something-is-planned-for-the-future?)

[How to indicate actions that were performed in the past?	3](#how-to-indicate-actions-that-were-performed-in-the-past?)

[How to express embargoes?	3](#how-to-express-embargoes?)

[Why are metadata referenced from a dataset?	3](#why-are-metadata-referenced-from-a-dataset?)

[Are there serializations other than JSON?	3](#are-there-serializations-other-than-json?)

## 

## ***How will the maDMP help me?*** {#how-will-the-madmp-help-me?}

The maDMP is the centralized go-to-place to find anything a person may want to know or communicate about a dataset at any point during the data lifecycle. This is provided via either a link to the source of the information, or in the maDMP itself if there is no other source. The maDMP provides a basis for automated approval of a dataset by management. The maDMP can be harvested to automatically provide information to the GC data catalogue or to a departmental data inventory. It can be queried to provide a customized report on the status of a dataset at any point during the data lifecycle. 

## ***Where do I deposit my maDMP?*** {#where-do-i-deposit-my-madmp?}

maDMPs should be deposited in a centralized maDMP repository. All maDMPs would then be searchable and accessible across all departments and agencies. 

## ***What happens to the maDMP when a dataset is archived at LAC or destroyed?*** {#what-happens-to-the-madmp-when-a-dataset-is-archived-at-lac-or-destroyed?}

The act of archiving or destroying a dataset should be recorded in the maDMP (anticipated date, then the actual date of the action). The maDMP itself should continue to exist in perpetuity. 

## ***When to use the maDMP Standard?*** {#when-to-use-the-madmp-standard?}

The standard is meant for exchange of machine-actionable maDMPs between systems. It is independent of any internal data organization used by these systems. The standard also does not prescribe how information must be presented to the end user and does not enforce any specific logic on how this information must be collected or used. The standard is an information carrier and the full machine-actionability can only be achieved when systems using the standard implement appropriate logic.

## ***Do I need to populate all fields?*** {#do-i-need-to-populate-all-fields?}

No. Only those fields for which the cardinality is set to "exactly one (1)" or "one to many (1..n)". Further fields defined in the standard may be set if required (by business constraints), or when the information becomes available. The standard aims to be flexible and for this reason many fields are optional. In specific deployments requirements may be stricter, for example: maDMP must contain information on a project number (funder requirement), while in the standard specification this is optional. All implementations or tools compliant with the standard, must expect to receive both obligatory and optional fields.

## ***What is the granularity of the maDMP?***  {#what-is-the-granularity-of-the-madmp?}

It depends on the specific context in which the maDMP is used. If an maDMP contains one dataset (the most generic setting), it can denote that all data, for which the maDMP is created, are considered jointly. For example, when an maDMP is created before a project begins, it contains minimum basic information and planned actions. If an maDMP contains more than one dataset, then each dataset can represent a logical group of data (e.g., raw data, software, publication, etc). Thus, the standard allows expressing that different datasets are handled differently. For example, software is deposited in a source code repository under embargo, while a publication is instantly available from a preprint server.

## ***What is the difference between a dataset and a distribution?*** {#what-is-the-difference-between-a-dataset-and-a-distribution?}

Dataset and Distribution are defined as in W3C DCAT specification. Dataset can be understood as a logical entity depicting data (e.g., raw data, software, publication, etc.). Distribution points to a specific instance of a dataset. Hence, distribution contains information such as format and size of files. A dataset can have several distributions. For example, a publication can be both available as PDF and DOCX. Furthermore, a dataset can have many distributions to indicate where the data are kept temporarily, for example during a project, and where the data are going to be published/archived at the end of a project.

## ***How does versioning work?*** {#how-does-versioning-work?}

Each maDMP has a *creation date* and a *modification timestamp*.The modification date contains a timestamp of the last modification of the maDMP. Having two maDMPs with different modification dates, one can identify which is newer by comparing timestamps. The same creation date indicates that we consider different versions of the same maDMP.

The standard itself does not have any mechanisms to model different versions of data \- if information is overwritten, then previous information is not kept in the model. Systems processing maDMPs must have suitable versioning mechanisms, if needed. This allows retrieval of different versions of an maDMP over time, while the maDMP itself contains the modification date allowing to identify/distinguish/refer to a specific maDMP version. The modification date must be set automatically by a tool that modified the maDMP.

## ***How to express that something is planned for the future?*** {#how-to-express-that-something-is-planned-for-the-future?}

Dates are used to indicate planned actions. An maDMP has a *modification timestamp* that contains a timestamp of the last maDMP modification. Dataset contains *issue* date that indicates whether the actions are planned or already performed. If the *issue date* is set in the future (compared to maDMP modification date), then the actions are planned. If the *issue date* is set in the past (compared to maDMP modification date), the actions were performed.

## ***How to indicate actions that were performed in the past?*** {#how-to-indicate-actions-that-were-performed-in-the-past?}

In a similar way as for the actions that were planned, the maDMP *modification timestamp* and *issue date* of a dataset are used to indicate actions that were performed in the past. If the *issue date* is set in the future (compared to maDMP *modification timestamp*), then the actions are planned. If the issue date is set in the past (compared to maDMP modification date), the actions were performed.

## ***How to express embargoes?*** {#how-to-express-embargoes?}

Embargo for data sharing means that data will be made available using a license, but not immediately after deposition of data in a repository. For each distribution, one can assign a license. If the license is assigned, then it means that a distribution at some point will become available. The start date set for the license indicates when it becomes binding \- in other words, when the distribution becomes available under this license.

## ***Why are metadata referenced from a dataset?*** {#why-are-metadata-referenced-from-a-dataset?}

The maDMP Standard assumes that one can define what metadata standards will be used, once he/she knows what data will be used. If an maDMP contains only one dataset and one or more metadata elements assigned to it, then this expresses in a generic way what metadata standards will be used in a project. However, if more datasets are created and metadata are attributed to one of them, then this denotes that the specific metadata standard will be used for the specific dataset.

## ***Are there serializations other than JSON?*** {#are-there-serializations-other-than-json?}

All the examples provided so far are in JSON, because of its popularity. The standard can be serialized to any other representation (e.g., XML, OWL, JSON-LD, etc.) if needed. The Research Data Alliance began work on an [RDA DMP common standard ontology (DCSO)](https://github.com/RDA-DMP-Common/RDA-DMP-Common-Standard/tree/master/ontologies), but this is still a work in progress.