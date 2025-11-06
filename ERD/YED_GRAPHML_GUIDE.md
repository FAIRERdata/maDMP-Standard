# Using yEd Graph Editor with the maDMP Database ERD

## Overview

The `madmp_database_schema_erd.graphml` file is a GraphML format Entity-Relationship Diagram that can be opened and edited with yEd Graph Editor. This guide shows you how to use yEd to visualize and customize the database schema.

## Getting Started

### 1. Download and Install yEd

1. Go to https://www.yworks.com/products/yed
2. Download yEd Graph Editor (it's free!)
3. Install and launch yEd

### 2. Open the GraphML File

1. In yEd, go to **File → Open**
2. Navigate to the `JSON` folder in your maDMP-Standard repository
3. Select `madmp_database_schema_erd.graphml`
4. Click **Open**

You'll see all 94 tables with their field names and 93 relationship edges.

## Automatic Layout

The initial layout is a simple grid. yEd provides powerful automatic layout algorithms to organize the diagram:

### Recommended Layouts

#### 1. Hierarchical Layout (Best for Database Schemas)

**Steps:**
1. Go to **Layout → Hierarchical**
2. In the dialog, configure:
   - **Orientation**: Top to Bottom or Left to Right
   - **Layer Assignment**: Hierarchical - Optimal
   - **Edge Routing**: Polyline or Orthogonal
3. Click **OK**

**Result:** Tables are arranged in hierarchical layers based on foreign key relationships, with the root `dmp` table at the top.

#### 2. Organic Layout (Natural Clustering)

**Steps:**
1. Go to **Layout → Organic**
2. Configure:
   - **Preferred Edge Length**: 100-150
   - **Quality**: High
3. Click **OK**

**Result:** Tables are arranged in a natural, force-directed layout that groups related tables together.

#### 3. Orthogonal Layout (Clean Right Angles)

**Steps:**
1. Go to **Layout → Orthogonal**
2. Configure as needed
3. Click **OK**

**Result:** All edges are drawn with right angles, creating a clean, structured appearance.

### Comparing Layouts

Try different layouts to see which works best for your needs:
- **Hierarchical**: Best for understanding parent-child relationships
- **Organic**: Best for seeing clusters and communities
- **Orthogonal**: Best for formal documentation
- **Circular**: Best for seeing overall connectivity

## Customizing the Diagram

### Selecting Elements

- **Select a single node**: Click on it
- **Select multiple nodes**: Hold Ctrl (Cmd on Mac) and click
- **Select all nodes**: Ctrl+A (Cmd+A on Mac)
- **Select by type**: Right-click → Select → Select Nodes/Edges

### Changing Node Colors

1. Select the nodes you want to color
2. Right-click → Properties
3. In the **Fill** section, choose a color
4. Click **OK**

**Tip:** Color-code tables by category:
- Root table (`dmp`): Blue
- Main entities (`dmp_dataset`, `dmp_project`, etc.): Green
- Nested objects: Yellow
- Junction tables (arrays): Orange

### Changing Node Size

1. Select nodes
2. Right-click → Properties
3. In the **Size** section, adjust width and height
4. Click **OK**

Or use **Tools → Fit Node to Label** to auto-size nodes based on content.

### Editing Labels

1. Double-click on a node
2. Edit the text
3. Press Enter

**Note:** The labels show the table name and all field names. You can edit this if needed.

### Changing Edge Styles

1. Select edges
2. Right-click → Properties
3. Configure:
   - **Line Type**: Solid, dashed, dotted
   - **Line Color**: Choose a color
   - **Arrows**: Source and target arrow styles
   - **Thickness**: Line width
4. Click **OK**

### Adding Labels to Edges

1. Select an edge
2. Right-click → Add Label
3. Type the label text (e.g., "has many", "belongs to")
4. Position the label by dragging

## Filtering and Focusing

### Hide/Show Elements

**Hide selected nodes:**
1. Select nodes
2. Right-click → Hide Selection

**Show all hidden nodes:**
- **Edit → Unhide All**

**Filter by properties:**
1. Go to **Tools → Neighborhood**
2. Select a node
3. Configure distance (1 = direct neighbors, 2 = neighbors of neighbors, etc.)
4. Click **OK**

This shows only the selected node and its neighbors, hiding everything else.

### Folding/Grouping

**Create a group:**
1. Select multiple nodes
2. Right-click → Grouping → Group
3. The nodes are now in a collapsible group

**Collapse/Expand groups:**
- Click the **+** or **-** icon on the group node

**Tip:** Group related tables together (e.g., all `dmp_dataset_*` tables) to simplify the view.

## Exporting the Diagram

### Export to Image (PNG, JPG, SVG)

1. Go to **File → Export**
2. Choose format:
   - **PNG**: For presentations and documents
   - **SVG**: For scalable vector graphics
   - **PDF**: For printing
3. Configure export settings:
   - **Margin**: Add space around the diagram
   - **Transparent Background**: For PNG
   - **Quality**: For JPG
4. Click **Export**

### Export to Other Formats

yEd supports many export formats:
- **PDF**: For documentation
- **SVG**: For web and scalable graphics
- **EMF**: For Microsoft Office
- **HTML Image Map**: For interactive web diagrams
- **GraphML**: To save your customized version

### Print

1. Go to **File → Print**
2. Configure print settings
3. Click **Print**

**Tip:** Use **File → Print Preview** to see how it will look before printing.

## Advanced Features

### Search and Highlight

1. Go to **Edit → Find**
2. Enter search term (e.g., "dataset")
3. yEd highlights all matching nodes

### Properties Mapper

Automatically style nodes based on their properties:

1. Go to **Tools → Properties Mapper**
2. Configure mappings (e.g., color by table name pattern)
3. Click **OK**

### Swimlanes

Add swimlanes to organize tables by category:

1. Go to **Edit → Manage Palette**
2. Add swimlane shapes
3. Drag swimlanes onto the canvas
4. Place tables within swimlanes

### Layers

Organize elements into layers:

1. Go to **View → Layers**
2. Create new layers
3. Assign nodes/edges to layers
4. Show/hide layers as needed

## Tips and Best Practices

### For Large Diagrams (94 tables)

1. **Use Hierarchical Layout** to see the overall structure
2. **Group related tables** to reduce visual complexity
3. **Use the Neighborhood tool** to focus on specific areas
4. **Export to PDF** for high-quality printing
5. **Use layers** to separate different parts of the schema

### For Presentations

1. **Use Organic Layout** for a visually appealing arrangement
2. **Color-code tables** by category
3. **Add edge labels** to explain relationships
4. **Export to PNG or SVG** for slides
5. **Use high contrast colors** for visibility

### For Documentation

1. **Use Orthogonal Layout** for a formal appearance
2. **Add descriptive labels** to edges
3. **Group tables** by functional area
4. **Export to PDF** with high resolution
5. **Include a legend** explaining colors and symbols

### For Analysis

1. **Use the Neighborhood tool** to explore relationships
2. **Search for specific tables** to highlight them
3. **Use different layouts** to see different perspectives
4. **Measure path lengths** between tables
5. **Identify central tables** (those with many connections)

## Keyboard Shortcuts

- **Ctrl+A** (Cmd+A): Select all
- **Ctrl+Z** (Cmd+Z): Undo
- **Ctrl+Y** (Cmd+Y): Redo
- **Ctrl+F** (Cmd+F): Find
- **Ctrl+G** (Cmd+G): Group
- **Ctrl+U** (Cmd+U): Ungroup
- **Delete**: Delete selected elements
- **F2**: Edit label
- **Ctrl+Mouse Wheel**: Zoom in/out
- **Space+Drag**: Pan the canvas

## Troubleshooting

### Diagram is too crowded

- Use **Layout → Hierarchical** with larger spacing
- Increase **Preferred Edge Length** in Organic layout
- Hide less important tables using **Hide Selection**
- Use **Grouping** to collapse related tables

### Edges overlap nodes

- Use **Layout → Hierarchical** with **Edge Routing: Orthogonal**
- Manually adjust edge paths by adding bend points (right-click edge → Add Bend)

### Can't see all tables

- Use **View → Fit Content** to zoom to show all elements
- Check if any elements are hidden (**Edit → Unhide All**)

### Export is too large/small

- Adjust **Zoom** before exporting
- Use **Export → Configure** to set custom dimensions
- For vector formats (SVG, PDF), size doesn't matter as much

## Example Workflows

### Workflow 1: Create a Presentation Diagram

1. Open the GraphML file in yEd
2. Apply **Layout → Organic**
3. Color-code tables:
   - Root table: Blue
   - Main entities: Green
   - Nested objects: Yellow
4. Add edge labels for key relationships
5. Export to PNG at 300 DPI

### Workflow 2: Focus on Dataset Tables

1. Open the GraphML file
2. Use **Edit → Find** to search for "dataset"
3. Select all dataset-related tables
4. Right-click → **Tools → Neighborhood** (distance: 1)
5. Apply **Layout → Hierarchical**
6. Export to PDF

### Workflow 3: Create Documentation

1. Open the GraphML file
2. Apply **Layout → Orthogonal**
3. Group tables by functional area
4. Add descriptive labels
5. Export to PDF with high resolution
6. Include in technical documentation

## Resources

- **yEd Manual**: https://yed.yworks.com/support/manual/
- **yEd Tutorial Videos**: https://www.yworks.com/products/yed/videos
- **GraphML Format**: http://graphml.graphdrawing.org/
- **yEd Forum**: https://yed.yworks.com/support/qa/

## Next Steps

After customizing your diagram in yEd:

1. **Save your work**: File → Save As (save as a new `.graphml` file)
2. **Share with team**: Export to PNG or PDF
3. **Update documentation**: Include the diagram in your README or wiki
4. **Iterate**: As the schema changes, regenerate the GraphML and reapply your customizations

## Regenerating the Diagram

When the database schema changes:

1. Run the generation script again:
   ```bash
   python generate_database_schema.py --erd
   ```

2. Open the new `madmp_database_schema_erd.graphml` in yEd

3. Reapply your customizations:
   - Layout algorithm
   - Colors and styles
   - Groups and labels

**Tip:** Save your customized version with a different name (e.g., `madmp_database_schema_erd_custom.graphml`) so you don't lose your work when regenerating.

