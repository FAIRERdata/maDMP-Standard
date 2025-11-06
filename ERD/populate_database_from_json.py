import json
import psycopg2
from typing import Dict, List, Any, Optional
from datetime import datetime

"""
Script name:    populate_database_from_json.py
Date written:   2025-01-04
Software:       Python 3.11+

Purpose:        Populate the maDMP relational database from a JSON instance
Input:          A JSON file conforming to the GCWG-RDA-maDMP schema
Output:         Data inserted into the PostgreSQL database
Dependencies:   psycopg2 (install with: pip install psycopg2-binary)

Usage:
    python populate_database_from_json.py --json madmp_instance.json --db madmp_database
"""

class DatabasePopulator:
    def __init__(self, db_connection_string: str):
        """Initialize the database populator with a connection string."""
        self.conn = psycopg2.connect(db_connection_string)
        self.cursor = self.conn.cursor()
        
    def close(self):
        """Close the database connection."""
        self.cursor.close()
        self.conn.close()
    
    def insert_and_get_id(self, table: str, data: Dict[str, Any], parent_id: Optional[int] = None, 
                          parent_column: Optional[str] = None, array_index: Optional[int] = None) -> int:
        """
        Insert a record into a table and return its ID.
        
        Args:
            table: Table name
            data: Dictionary of column names and values
            parent_id: ID of the parent record (for foreign keys)
            parent_column: Name of the parent foreign key column
            array_index: Index in array (for array tables)
        
        Returns:
            The ID of the inserted record
        """
        # Add parent_id if provided
        if parent_id is not None and parent_column:
            data[parent_column] = parent_id
        
        # Add array_index if provided
        if array_index is not None:
            data['array_index'] = array_index
        
        # Build INSERT statement
        columns = list(data.keys())
        values = [data[col] for col in columns]
        placeholders = ', '.join(['%s'] * len(columns))
        column_names = ', '.join(columns)
        
        query = f"INSERT INTO {table} ({column_names}) VALUES ({placeholders}) RETURNING id"
        
        try:
            self.cursor.execute(query, values)
            record_id = self.cursor.fetchone()[0]
            return record_id
        except Exception as e:
            print(f"Error inserting into {table}: {e}")
            print(f"Data: {data}")
            raise
    
    def process_dmp(self, dmp_data: Dict[str, Any]) -> int:
        """
        Process the root DMP object and all its nested structures.
        
        Args:
            dmp_data: The DMP JSON object
        
        Returns:
            The ID of the inserted DMP record
        """
        # Insert root DMP record
        dmp_id = self.insert_and_get_id('dmp', {})
        
        # Process general_info
        if 'general_info' in dmp_data:
            self.process_general_info(dmp_data['general_info'], dmp_id)
        
        # Process contact
        if 'contact' in dmp_data:
            self.process_contact(dmp_data['contact'], dmp_id)
        
        # Process contributors (array)
        if 'contributor' in dmp_data:
            for idx, contributor in enumerate(dmp_data['contributor']):
                self.process_contributor(contributor, dmp_id, idx)
        
        # Process approval
        if 'approval' in dmp_data:
            self.process_approval(dmp_data['approval'], dmp_id)
        
        # Process projects (array)
        if 'project' in dmp_data:
            for idx, project in enumerate(dmp_data['project']):
                self.process_project(project, dmp_id, idx)
        
        # Process costs (array)
        if 'cost' in dmp_data:
            for idx, cost in enumerate(dmp_data['cost']):
                self.process_cost(cost, dmp_id, idx)
        
        # Process indigenous_considerations
        if 'indigenous_considerations' in dmp_data:
            self.process_indigenous_considerations(dmp_data['indigenous_considerations'], dmp_id)
        
        # Process datasets (array)
        if 'dataset' in dmp_data:
            for idx, dataset in enumerate(dmp_data['dataset']):
                self.process_dataset(dataset, dmp_id, idx)
        
        return dmp_id
    
    def process_general_info(self, general_info: Dict[str, Any], dmp_id: int) -> int:
        """Process the general_info object."""
        data = {
            'dmp_id': dmp_id,
            'title': general_info.get('title'),
            'description': general_info.get('description'),
            'created': general_info.get('created'),
            'modified': general_info.get('modified'),
            'language': general_info.get('language'),
            'ethical_issues_exist': general_info.get('ethical_issues_exist'),
            'ethical_issues_description': general_info.get('ethical_issues_description'),
            'ethical_issues_report': general_info.get('ethical_issues_report'),
        }
        
        # Remove None values
        data = {k: v for k, v in data.items() if v is not None}
        
        general_info_id = self.insert_and_get_id('dmp_general_info', data)
        
        # Process dmp_id (nested object)
        if 'dmp_id' in general_info:
            self.process_dmp_id(general_info['dmp_id'], general_info_id)
        
        # Process linked_dmp (array)
        if 'linked_dmp' in general_info:
            for idx, linked_dmp in enumerate(general_info['linked_dmp']):
                self.process_linked_dmp(linked_dmp, general_info_id, idx)
        
        return general_info_id
    
    def process_dmp_id(self, dmp_id_obj: Dict[str, Any], general_info_id: int) -> int:
        """Process the dmp_id object."""
        data = {
            'dmp_general_info_id': general_info_id,
            'identifier': dmp_id_obj.get('identifier'),
            'type': dmp_id_obj.get('type'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        return self.insert_and_get_id('dmp_general_info_dmp_id', data)
    
    def process_linked_dmp(self, linked_dmp: Dict[str, Any], general_info_id: int, idx: int) -> int:
        """Process a linked_dmp object."""
        data = {
            'dmp_general_info_id': general_info_id,
            'array_index': idx,
            'relationship_type': linked_dmp.get('relationship_type'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        linked_dmp_id = self.insert_and_get_id('dmp_general_info_linked_dmp', data)
        
        # Process linked_dmp_id (array)
        if 'linked_dmp_id' in linked_dmp:
            for sub_idx, linked_dmp_id_obj in enumerate(linked_dmp['linked_dmp_id']):
                self.process_linked_dmp_id(linked_dmp_id_obj, linked_dmp_id, sub_idx)
        
        return linked_dmp_id
    
    def process_linked_dmp_id(self, linked_dmp_id_obj: Dict[str, Any], linked_dmp_id: int, idx: int) -> int:
        """Process a linked_dmp_id object."""
        data = {
            'dmp_general_info_linked_dmp_id': linked_dmp_id,
            'array_index': idx,
            'identifier': linked_dmp_id_obj.get('identifier'),
            'type': linked_dmp_id_obj.get('type'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        return self.insert_and_get_id('dmp_general_info_linked_dmp_linked_dmp_id', data)
    
    def process_contact(self, contact: Dict[str, Any], dmp_id: int) -> int:
        """Process the contact object."""
        data = {
            'dmp_id': dmp_id,
            'name': contact.get('name'),
            'mbox': contact.get('mbox'),
            'role': contact.get('role'),
            'url': contact.get('url'),
            'organization': contact.get('organization'),
            'position': contact.get('position'),
            'delivery_point': contact.get('delivery_point'),
            'city': contact.get('city'),
            'postal_zip_code': contact.get('postal_zip_code'),
            'hours_of_service': contact.get('hours_of_service'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        contact_id = self.insert_and_get_id('dmp_contact', data)
        
        # Process contact_id (nested object)
        if 'contact_id' in contact:
            self.process_contact_id(contact['contact_id'], contact_id)
        
        # Process affiliation (array)
        if 'affiliation' in contact:
            for idx, affiliation in enumerate(contact['affiliation']):
                self.process_contact_affiliation(affiliation, contact_id, idx)
        
        # Process telephone (array of primitives)
        if 'telephone' in contact:
            for idx, phone in enumerate(contact['telephone']):
                self.insert_and_get_id('dmp_contact_telephone', 
                                      {'value': phone}, 
                                      contact_id, 
                                      'dmp_contact_id', 
                                      idx)
        
        # Process fax (array of primitives)
        if 'fax' in contact:
            for idx, fax in enumerate(contact['fax']):
                self.insert_and_get_id('dmp_contact_fax', 
                                      {'value': fax}, 
                                      contact_id, 
                                      'dmp_contact_id', 
                                      idx)
        
        return contact_id
    
    def process_contact_id(self, contact_id_obj: Dict[str, Any], contact_id: int) -> int:
        """Process the contact_id object."""
        data = {
            'dmp_contact_id': contact_id,
            'identifier': contact_id_obj.get('identifier'),
            'type': contact_id_obj.get('type'),
            'registry_url': contact_id_obj.get('registry_url'),
            'registry_version': contact_id_obj.get('registry_version'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        return self.insert_and_get_id('dmp_contact_contact_id', data)
    
    def process_contact_affiliation(self, affiliation: Dict[str, Any], contact_id: int, idx: int) -> int:
        """Process a contact affiliation object."""
        data = {
            'dmp_contact_id': contact_id,
            'array_index': idx,
            'contact_affiliation_name': affiliation.get('contact_affiliation_name'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        affiliation_id = self.insert_and_get_id('dmp_contact_affiliation', data)
        
        # Process nested objects (contact_affiliation_id, contact_country, contact_province_state)
        # ... (similar pattern as above)
        
        return affiliation_id
    
    # Additional methods would follow the same pattern for:
    # - process_contributor
    # - process_approval
    # - process_project
    # - process_cost
    # - process_indigenous_considerations
    # - process_dataset (and all its nested structures)
    
    def process_contributor(self, contributor: Dict[str, Any], dmp_id: int, idx: int) -> int:
        """Process a contributor object. (Simplified example)"""
        data = {
            'dmp_id': dmp_id,
            'array_index': idx,
            'name': contributor.get('name'),
            'mbox': contributor.get('mbox'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        contributor_id = self.insert_and_get_id('dmp_contributor', data)
        
        # Process role (array of primitives)
        if 'role' in contributor:
            for role_idx, role in enumerate(contributor['role']):
                self.insert_and_get_id('dmp_contributor_role', 
                                      {'value': role}, 
                                      contributor_id, 
                                      'dmp_contributor_id', 
                                      role_idx)
        
        return contributor_id
    
    def process_dataset(self, dataset: Dict[str, Any], dmp_id: int, idx: int) -> int:
        """Process a dataset object. (Simplified example)"""
        data = {
            'dmp_id': dmp_id,
            'array_index': idx,
            'title': dataset.get('title'),
            'description': dataset.get('description'),
            'type': dataset.get('type'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        dataset_id = self.insert_and_get_id('dmp_dataset', data)
        
        # Process distributions (array)
        if 'distribution' in dataset:
            for dist_idx, distribution in enumerate(dataset['distribution']):
                self.process_distribution(distribution, dataset_id, dist_idx)
        
        return dataset_id
    
    def process_distribution(self, distribution: Dict[str, Any], dataset_id: int, idx: int) -> int:
        """Process a distribution object. (Simplified example)"""
        data = {
            'dmp_dataset_id': dataset_id,
            'array_index': idx,
            'title': distribution.get('title'),
            'description': distribution.get('description'),
            'byte_size': distribution.get('byte_size'),
        }
        
        data = {k: v for k, v in data.items() if v is not None}
        return self.insert_and_get_id('dmp_dataset_distribution', data)
    
    # Stub methods for other entities
    def process_approval(self, approval: Dict[str, Any], dmp_id: int) -> int:
        """Process approval object."""
        pass
    
    def process_project(self, project: Dict[str, Any], dmp_id: int, idx: int) -> int:
        """Process project object."""
        pass
    
    def process_cost(self, cost: Dict[str, Any], dmp_id: int, idx: int) -> int:
        """Process cost object."""
        pass
    
    def process_indigenous_considerations(self, indigenous: Dict[str, Any], dmp_id: int) -> int:
        """Process indigenous_considerations object."""
        pass


def main():
    """Main function to populate the database from a JSON file."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Populate maDMP database from a JSON instance'
    )
    parser.add_argument(
        '--json',
        required=True,
        help='Path to the JSON file containing the maDMP instance'
    )
    parser.add_argument(
        '--db',
        default='postgresql://localhost/madmp_database',
        help='Database connection string (default: postgresql://localhost/madmp_database)'
    )
    
    args = parser.parse_args()
    
    # Load JSON file
    print(f"Loading JSON from: {args.json}")
    with open(args.json, 'r', encoding='utf-8') as f:
        madmp_data = json.load(f)
    
    # Connect to database and populate
    print(f"Connecting to database: {args.db}")
    populator = DatabasePopulator(args.db)
    
    try:
        # Process the DMP
        if 'dmp' in madmp_data:
            dmp_id = populator.process_dmp(madmp_data['dmp'])
            populator.conn.commit()
            print(f"Successfully inserted DMP with ID: {dmp_id}")
        else:
            print("Error: JSON file does not contain a 'dmp' object")
    
    except Exception as e:
        print(f"Error populating database: {e}")
        populator.conn.rollback()
        raise
    
    finally:
        populator.close()


if __name__ == '__main__':
    main()

