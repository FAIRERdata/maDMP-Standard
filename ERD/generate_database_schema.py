import json
import re
from typing import Dict, List, Tuple, Set

"""
Script name:    generate_database_schema.py
Date written:   2025-01-04
Software:       Python 3.11+

Purpose:        Generate a relational database schema (SQL DDL) from the GCWG-RDA-maDMP JSON schema
Input:          GCWG-RDA-maDMP-schema.json
Output:         SQL DDL statements for creating database tables
"""

class DatabaseSchemaGenerator:
    def __init__(self, json_schema_path: str):
        """Initialize the generator with a JSON schema file."""
        with open(json_schema_path, 'r', encoding='utf-8') as f:
            self.schema = json.load(f)
        
        self.tables = {}  # Store table definitions
        self.foreign_keys = []  # Store foreign key relationships
        self.processed_paths = set()  # Track processed paths to avoid duplicates
        
    def sanitize_name(self, name: str) -> str:
        """Convert a name to a valid SQL identifier."""
        # Replace special characters with underscores
        name = re.sub(r'[^a-zA-Z0-9_]', '_', name)
        # Ensure it doesn't start with a number
        if name and name[0].isdigit():
            name = 'f_' + name
        # Limit length to 63 characters (PostgreSQL limit)
        if len(name) > 63:
            name = name[:63]
        return name.lower()
    
    def get_sql_type(self, json_type: str, format_type: str = None, enum_values: List = None) -> str:
        """Map JSON schema types to SQL types."""
        if enum_values:
            # For enums with many values, use VARCHAR; for few values, could use ENUM
            return 'VARCHAR(255)'
        
        if format_type:
            if format_type == 'date':
                return 'DATE'
            elif format_type == 'date-time':
                return 'TIMESTAMP'
            elif format_type in ('uri', 'url', 'email'):
                return 'VARCHAR(2048)'
        
        type_mapping = {
            'string': 'TEXT',
            'number': 'NUMERIC',
            'integer': 'INTEGER',
            'boolean': 'BOOLEAN',
            'object': None,  # Objects become separate tables
            'array': None,   # Arrays become separate tables
        }
        
        return type_mapping.get(json_type, 'TEXT')
    
    def create_table_name(self, path: str) -> str:
        """Create a table name from a JSON path."""
        # Remove leading/trailing slashes and convert to table name
        parts = [p for p in path.split('/') if p]
        return self.sanitize_name('_'.join(parts))
    
    def extract_properties(self, properties: Dict, parent_path: str, parent_table: str = None) -> None:
        """Recursively extract properties and create table definitions."""
        
        for prop_name, prop_def in properties.items():
            current_path = f"{parent_path}/{prop_name}".strip('/')
            
            # Skip if already processed
            if current_path in self.processed_paths:
                continue
            
            prop_type = prop_def.get('type')
            
            if prop_type == 'object':
                # Create a new table for this object
                table_name = self.create_table_name(current_path)
                self.processed_paths.add(current_path)
                
                # Initialize table if not exists
                if table_name not in self.tables:
                    self.tables[table_name] = {
                        'columns': [],
                        'description': prop_def.get('description', ''),
                        'path': current_path
                    }
                    
                    # Add primary key
                    self.tables[table_name]['columns'].append({
                        'name': 'id',
                        'type': 'SERIAL PRIMARY KEY',
                        'description': 'Auto-generated primary key'
                    })
                    
                    # Add foreign key to parent if exists
                    if parent_table:
                        fk_column = f"{parent_table}_id"
                        self.tables[table_name]['columns'].append({
                            'name': fk_column,
                            'type': 'INTEGER',
                            'description': f'Foreign key to {parent_table}'
                        })
                        self.foreign_keys.append({
                            'table': table_name,
                            'column': fk_column,
                            'ref_table': parent_table,
                            'ref_column': 'id'
                        })
                
                # Process nested properties
                if 'properties' in prop_def:
                    self.extract_properties(prop_def['properties'], current_path, table_name)
                    
            elif prop_type == 'array':
                # Handle arrays
                items = prop_def.get('items', {})
                items_type = items.get('type')
                
                if items_type == 'object':
                    # Array of objects - create a separate table
                    table_name = self.create_table_name(current_path)
                    self.processed_paths.add(current_path)
                    
                    if table_name not in self.tables:
                        self.tables[table_name] = {
                            'columns': [],
                            'description': items.get('description', prop_def.get('description', '')),
                            'path': current_path
                        }
                        
                        # Add primary key
                        self.tables[table_name]['columns'].append({
                            'name': 'id',
                            'type': 'SERIAL PRIMARY KEY',
                            'description': 'Auto-generated primary key'
                        })
                        
                        # Add foreign key to parent
                        if parent_table:
                            fk_column = f"{parent_table}_id"
                            self.tables[table_name]['columns'].append({
                                'name': fk_column,
                                'type': 'INTEGER NOT NULL',
                                'description': f'Foreign key to {parent_table}'
                            })
                            self.foreign_keys.append({
                                'table': table_name,
                                'column': fk_column,
                                'ref_table': parent_table,
                                'ref_column': 'id'
                            })
                        
                        # Add array index column
                        self.tables[table_name]['columns'].append({
                            'name': 'array_index',
                            'type': 'INTEGER',
                            'description': 'Position in the array'
                        })
                    
                    # Process nested properties
                    if 'properties' in items:
                        self.extract_properties(items['properties'], current_path, table_name)
                        
                else:
                    # Array of primitives - create a simple junction table
                    table_name = self.create_table_name(current_path)
                    self.processed_paths.add(current_path)
                    
                    if table_name not in self.tables:
                        sql_type = self.get_sql_type(
                            items_type or 'string',
                            items.get('format'),
                            items.get('enum')
                        )
                        
                        self.tables[table_name] = {
                            'columns': [
                                {
                                    'name': 'id',
                                    'type': 'SERIAL PRIMARY KEY',
                                    'description': 'Auto-generated primary key'
                                }
                            ],
                            'description': prop_def.get('description', ''),
                            'path': current_path
                        }
                        
                        # Add foreign key to parent
                        if parent_table:
                            fk_column = f"{parent_table}_id"
                            self.tables[table_name]['columns'].append({
                                'name': fk_column,
                                'type': 'INTEGER NOT NULL',
                                'description': f'Foreign key to {parent_table}'
                            })
                            self.foreign_keys.append({
                                'table': table_name,
                                'column': fk_column,
                                'ref_table': parent_table,
                                'ref_column': 'id'
                            })
                        
                        # Add value column
                        self.tables[table_name]['columns'].append({
                            'name': 'value',
                            'type': sql_type,
                            'description': items.get('description', prop_def.get('description', ''))
                        })
                        
                        # Add array index
                        self.tables[table_name]['columns'].append({
                            'name': 'array_index',
                            'type': 'INTEGER',
                            'description': 'Position in the array'
                        })
                        
            else:
                # Simple property - add as column to parent table
                if parent_table and parent_table in self.tables:
                    sql_type = self.get_sql_type(
                        prop_type,
                        prop_def.get('format'),
                        prop_def.get('enum')
                    )
                    
                    if sql_type:  # Only add if we have a valid SQL type
                        column_name = self.sanitize_name(prop_name)
                        
                        # Check if column already exists
                        existing_columns = [c['name'] for c in self.tables[parent_table]['columns']]
                        if column_name not in existing_columns:
                            self.tables[parent_table]['columns'].append({
                                'name': column_name,
                                'type': sql_type,
                                'description': prop_def.get('description', ''),
                                'example': prop_def.get('example', ''),
                                'question': prop_def.get('question', '')
                            })

    def generate_sql(self, database_type: str = 'postgresql') -> str:
        """Generate SQL DDL statements for the database schema."""
        sql_statements = []

        # Add header comment
        sql_statements.append("-- Database schema generated from GCWG-RDA-maDMP JSON Schema")
        sql_statements.append(f"-- Generated on: 2025-01-04")
        sql_statements.append(f"-- Database type: {database_type}")
        sql_statements.append("")

        # Generate CREATE TABLE statements
        for table_name, table_def in sorted(self.tables.items()):
            sql_statements.append(f"-- Table: {table_name}")
            if table_def['description']:
                sql_statements.append(f"-- Description: {table_def['description'][:200]}")
            sql_statements.append(f"-- Path: {table_def['path']}")

            sql_statements.append(f"CREATE TABLE {table_name} (")

            # Add columns
            column_defs = []
            for col in table_def['columns']:
                col_def = f"    {col['name']} {col['type']}"

                # Add comment if description exists
                if col.get('description'):
                    # Escape single quotes in description
                    desc = col['description'].replace("'", "''")[:200]
                    col_def += f"  -- {desc}"

                column_defs.append(col_def)

            sql_statements.append(',\n'.join(column_defs))
            sql_statements.append(");")
            sql_statements.append("")

        # Generate ALTER TABLE statements for foreign keys
        if self.foreign_keys:
            sql_statements.append("-- Foreign Key Constraints")
            sql_statements.append("")

            for fk in self.foreign_keys:
                constraint_name = f"fk_{fk['table']}_{fk['column']}"
                sql_statements.append(
                    f"ALTER TABLE {fk['table']} "
                    f"ADD CONSTRAINT {constraint_name} "
                    f"FOREIGN KEY ({fk['column']}) "
                    f"REFERENCES {fk['ref_table']}({fk['ref_column']}) "
                    f"ON DELETE CASCADE;"
                )
            sql_statements.append("")

        # Generate indexes for foreign keys
        sql_statements.append("-- Indexes for Foreign Keys")
        sql_statements.append("")

        for fk in self.foreign_keys:
            index_name = f"idx_{fk['table']}_{fk['column']}"
            sql_statements.append(
                f"CREATE INDEX {index_name} ON {fk['table']}({fk['column']});"
            )

        sql_statements.append("")

        # Add comments on tables (PostgreSQL specific)
        if database_type == 'postgresql':
            sql_statements.append("-- Table Comments")
            sql_statements.append("")

            for table_name, table_def in sorted(self.tables.items()):
                if table_def['description']:
                    desc = table_def['description'].replace("'", "''")
                    sql_statements.append(
                        f"COMMENT ON TABLE {table_name} IS '{desc}';"
                    )

            sql_statements.append("")

        return '\n'.join(sql_statements)

    def generate_erd_mermaid(self) -> str:
        """Generate a Mermaid ERD diagram definition."""
        mermaid_lines = ["erDiagram"]

        # Track relationships
        relationships = {}

        for fk in self.foreign_keys:
            parent = fk['ref_table']
            child = fk['table']

            # Determine relationship type (one-to-many for most cases)
            rel_key = f"{parent}_{child}"
            if rel_key not in relationships:
                relationships[rel_key] = {
                    'parent': parent,
                    'child': child,
                    'type': '||--o{'  # One-to-many
                }

        # Add relationships
        for rel in relationships.values():
            mermaid_lines.append(
                f"    {rel['parent']} {rel['type']} {rel['child']} : \"has\""
            )

        # Add table definitions - show only field names
        for table_name, table_def in sorted(self.tables.items()):
            mermaid_lines.append(f"    {table_name} {{")

            # Show all columns with just their names
            for col in table_def['columns']:
                mermaid_lines.append(f"        string {col['name']}")

            mermaid_lines.append("    }")

        return '\n'.join(mermaid_lines)

    def generate_erd_graphml(self) -> str:
        """Generate a GraphML ERD diagram for yEd Graph Editor."""
        # GraphML header
        graphml_lines = [
            '<?xml version="1.0" encoding="UTF-8" standalone="no"?>',
            '<graphml xmlns="http://graphml.graphdrawing.org/xmlns" '
            'xmlns:java="http://www.yworks.com/xml/yfiles-common/1.0/java" '
            'xmlns:sys="http://www.yworks.com/xml/yfiles-common/markup/primitives/2.0" '
            'xmlns:x="http://www.yworks.com/xml/yfiles-common/markup/2.0" '
            'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
            'xmlns:y="http://www.yworks.com/xml/graphml" '
            'xmlns:yed="http://www.yworks.com/xml/yed/3" '
            'xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns '
            'http://www.yworks.com/xml/schema/graphml/1.1/ygraphml.xsd">',
            '  <key for="node" id="d0" yfiles.type="nodegraphics"/>',
            '  <key for="edge" id="d1" yfiles.type="edgegraphics"/>',
            '  <graph edgedefault="directed" id="G">',
        ]

        # Track node IDs
        node_ids = {}
        node_counter = 0

        # Calculate layout positions (simple grid layout)
        tables_list = sorted(self.tables.keys())
        cols = 5  # Number of columns in grid
        x_spacing = 250
        y_spacing = 250  # Increased spacing for table name label below

        # Create nodes for each table
        for idx, table_name in enumerate(tables_list):
            node_id = f"n{node_counter}"
            node_ids[table_name] = node_id
            node_counter += 1

            # Calculate position
            col = idx % cols
            row = idx // cols
            x = col * x_spacing
            y = row * y_spacing

            # Get table columns
            table_def = self.tables[table_name]
            columns = table_def['columns']

            # Build field list (just names, no table name in this label)
            field_lines = []
            for col_def in columns:
                field_lines.append(col_def['name'])

            # Calculate node height based on number of fields
            header_height = 20
            field_height = 18
            total_height = header_height + (len(field_lines) * field_height)
            node_width = 200

            # Create node with table structure
            graphml_lines.append(f'    <node id="{node_id}">')
            graphml_lines.append('      <data key="d0">')
            graphml_lines.append('        <y:GenericNode configuration="com.yworks.entityRelationship.big_entity">')
            graphml_lines.append(f'          <y:Geometry height="{total_height}" width="{node_width}" x="{x}" y="{y}"/>')
            graphml_lines.append('          <y:Fill color="#E8EEF7" color2="#B7C9E3" transparent="false"/>')
            graphml_lines.append('          <y:BorderStyle color="#000000" type="line" width="1.0"/>')

            # First label: Field names only (inside the box)
            field_text = "\n".join(field_lines)
            graphml_lines.append(f'          <y:NodeLabel alignment="left" autoSizePolicy="content" '
                               f'fontFamily="Dialog" fontSize="11" fontStyle="plain" '
                               f'hasBackgroundColor="false" hasLineColor="false" '
                               f'modelName="internal" modelPosition="c" '
                               f'textColor="#000000" visible="true">{self._escape_xml(field_text)}</y:NodeLabel>')

            # Second label: Table name (below the box)
            graphml_lines.append(f'          <y:NodeLabel alignment="center" autoSizePolicy="content" '
                               f'fontFamily="Dialog" fontSize="13" fontStyle="bold" '
                               f'hasBackgroundColor="false" hasLineColor="false" '
                               f'modelName="custom" '
                               f'textColor="#000000" visible="true">{self._escape_xml(table_name)}'
                               f'<y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel>'
                               f'<y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.5" '
                               f'nodeRatioX="0.0" nodeRatioY="1.0" offsetX="0.0" offsetY="4.0" upX="0.0" upY="-1.0"/>'
                               f'</y:ModelParameter></y:NodeLabel>')

            graphml_lines.append('          <y:StyleProperties>')
            graphml_lines.append('            <y:Property class="java.lang.Boolean" name="y.view.ShadowNodePainter.SHADOW_PAINTING" value="true"/>')
            graphml_lines.append('          </y:StyleProperties>')
            graphml_lines.append('        </y:GenericNode>')
            graphml_lines.append('      </data>')
            graphml_lines.append('    </node>')

        # Create edges for foreign key relationships
        edge_counter = 0
        for fk in self.foreign_keys:
            parent_table = fk['ref_table']
            child_table = fk['table']

            if parent_table in node_ids and child_table in node_ids:
                edge_id = f"e{edge_counter}"
                edge_counter += 1

                # Determine cardinality based on table structure
                child_table_def = self.tables[child_table]
                child_columns = [col['name'] for col in child_table_def['columns']]

                # Check if this is an array relationship (has array_index column)
                is_array = 'array_index' in child_columns

                # Check if foreign key is NOT NULL
                fk_column_def = next((col for col in child_table_def['columns'] if col['name'] == fk['column']), None)
                is_required = fk_column_def and 'NOT NULL' in fk_column_def.get('type', '')

                # Determine cardinality
                # Parent side is always "1" (one parent)
                # Child side depends on whether it's an array and if it's required
                parent_cardinality = "1"
                if is_array:
                    child_cardinality = "0..*"  # Array can have zero or more items
                elif is_required:
                    child_cardinality = "1"     # Required single object
                else:
                    child_cardinality = "0..1"  # Optional single object

                graphml_lines.append(f'    <edge id="{edge_id}" source="{node_ids[parent_table]}" target="{node_ids[child_table]}">')
                graphml_lines.append('      <data key="d1">')
                graphml_lines.append('        <y:PolyLineEdge>')
                graphml_lines.append('          <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>')
                graphml_lines.append('          <y:LineStyle color="#000000" type="line" width="1.0"/>')
                graphml_lines.append('          <y:Arrows source="none" target="standard"/>')
                graphml_lines.append('          <y:BendStyle smoothed="false"/>')

                # Add source cardinality label (parent side)
                graphml_lines.append(f'          <y:EdgeLabel alignment="center" configuration="AutoFlippingLabel" '
                                   f'distance="2.0" fontFamily="Dialog" fontSize="10" fontStyle="plain" '
                                   f'hasBackgroundColor="false" hasLineColor="false" '
                                   f'modelName="six_pos" modelPosition="shead" '
                                   f'preferredPlacement="anywhere" ratio="0.5" textColor="#000000" '
                                   f'visible="true">{parent_cardinality}</y:EdgeLabel>')

                # Add target cardinality label (child side)
                graphml_lines.append(f'          <y:EdgeLabel alignment="center" configuration="AutoFlippingLabel" '
                                   f'distance="2.0" fontFamily="Dialog" fontSize="10" fontStyle="plain" '
                                   f'hasBackgroundColor="false" hasLineColor="false" '
                                   f'modelName="six_pos" modelPosition="thead" '
                                   f'preferredPlacement="anywhere" ratio="0.5" textColor="#000000" '
                                   f'visible="true">{child_cardinality}</y:EdgeLabel>')

                graphml_lines.append('        </y:PolyLineEdge>')
                graphml_lines.append('      </data>')
                graphml_lines.append('    </edge>')

        # GraphML footer
        graphml_lines.append('  </graph>')
        graphml_lines.append('</graphml>')

        return '\n'.join(graphml_lines)

    def _escape_xml(self, text: str) -> str:
        """Escape special XML characters."""
        text = text.replace('&', '&amp;')
        text = text.replace('<', '&lt;')
        text = text.replace('>', '&gt;')
        text = text.replace('"', '&quot;')
        text = text.replace("'", '&apos;')
        return text

    def generate_summary(self) -> str:
        """Generate a summary of the database schema."""
        summary_lines = []

        summary_lines.append("=" * 80)
        summary_lines.append("DATABASE SCHEMA SUMMARY")
        summary_lines.append("=" * 80)
        summary_lines.append("")

        summary_lines.append(f"Total Tables: {len(self.tables)}")
        summary_lines.append(f"Total Foreign Keys: {len(self.foreign_keys)}")
        summary_lines.append("")

        # Count columns
        total_columns = sum(len(t['columns']) for t in self.tables.values())
        summary_lines.append(f"Total Columns: {total_columns}")
        summary_lines.append("")

        # List tables with column counts
        summary_lines.append("Tables:")
        summary_lines.append("-" * 80)

        for table_name, table_def in sorted(self.tables.items()):
            col_count = len(table_def['columns'])
            desc = table_def['description'][:60] + "..." if len(table_def['description']) > 60 else table_def['description']
            summary_lines.append(f"  {table_name:40} ({col_count:3} columns) - {desc}")

        summary_lines.append("")
        summary_lines.append("=" * 80)

        return '\n'.join(summary_lines)

    def process_schema(self):
        """Main method to process the JSON schema."""
        # Start from the root 'dmp' object
        if 'properties' in self.schema and 'dmp' in self.schema['properties']:
            dmp_properties = self.schema['properties']['dmp'].get('properties', {})

            # Create the root 'dmp' table
            self.tables['dmp'] = {
                'columns': [
                    {
                        'name': 'id',
                        'type': 'SERIAL PRIMARY KEY',
                        'description': 'Auto-generated primary key'
                    }
                ],
                'description': self.schema['properties']['dmp'].get('description', 'Root DMP object'),
                'path': 'dmp'
            }
            self.processed_paths.add('dmp')

            # Process all properties under dmp
            self.extract_properties(dmp_properties, 'dmp', 'dmp')


def main():
    """Main function to generate database schema."""
    import argparse

    parser = argparse.ArgumentParser(
        description='Generate relational database schema from GCWG-RDA-maDMP JSON Schema'
    )
    parser.add_argument(
        '--input',
        default='GCWG-RDA-maDMP-schema.json',
        help='Path to the JSON schema file (default: GCWG-RDA-maDMP-schema.json)'
    )
    parser.add_argument(
        '--output',
        default='madmp_database_schema.sql',
        help='Path to the output SQL file (default: madmp_database_schema.sql)'
    )
    parser.add_argument(
        '--database',
        choices=['postgresql', 'mysql', 'sqlite'],
        default='postgresql',
        help='Target database type (default: postgresql)'
    )
    parser.add_argument(
        '--summary',
        action='store_true',
        help='Print summary of the generated schema'
    )
    parser.add_argument(
        '--erd',
        action='store_true',
        help='Generate Mermaid ERD diagram'
    )

    args = parser.parse_args()

    print(f"Processing JSON schema: {args.input}")

    # Create generator and process schema
    generator = DatabaseSchemaGenerator(args.input)
    generator.process_schema()

    # Generate SQL
    sql = generator.generate_sql(args.database)

    # Write to file
    with open(args.output, 'w', encoding='utf-8') as f:
        f.write(sql)

    print(f"SQL schema written to: {args.output}")

    # Print summary if requested
    if args.summary:
        print("\n" + generator.generate_summary())

    # Generate ERD if requested
    if args.erd:
        # Generate Mermaid ERD
        erd_mermaid_output = args.output.replace('.sql', '_erd.mmd')
        mermaid = generator.generate_erd_mermaid()
        with open(erd_mermaid_output, 'w', encoding='utf-8') as f:
            f.write(mermaid)
        print(f"Mermaid ERD written to: {erd_mermaid_output}")

        # Generate GraphML ERD for yEd
        erd_graphml_output = args.output.replace('.sql', '_erd.graphml')
        graphml = generator.generate_erd_graphml()
        with open(erd_graphml_output, 'w', encoding='utf-8') as f:
            f.write(graphml)
        print(f"GraphML ERD written to: {erd_graphml_output}")


if __name__ == '__main__':
    main()

