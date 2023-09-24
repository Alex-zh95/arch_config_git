import subprocess
import networkx as nx
import matplotlib.pyplot as plt
import sys

# List of packages you want to check
package_list = ["python", "firefox"]  # Replace with your package names

# Initialize a directed graph to represent the dependency tree
dependency_graph = nx.DiGraph()

# Initialize a dictionary to store package dependencies
package_dependencies = {}

# Run 'pacman -Qqe' to list all explicitly installed packages
installed_packages = subprocess.check_output(["pacman", "-Qqe"]).decode("utf-8").split("\n")

# Filter the installed packages based on the predefined package list
installed_packages = [pkg for pkg in installed_packages if pkg in package_list]

# Iterate through the installed packages and check for dependencies
for package in installed_packages:
    # Run 'pactree -r' to get the reverse dependencies of the package
    dependencies = subprocess.check_output(["pactree", "-rl", package]).decode("utf-8").split("\n")

    # Store the dependencies for the current package
    package_dependencies[package] = dependencies

# Build the dependency graph
for package, dependencies in package_dependencies.items():
    for dep in dependencies:
        dependency_graph.add_edge(package, dep)

# Visualize the dependency tree using matplotlib
pos = nx.spring_layout(dependency_graph)
nx.draw(dependency_graph, pos, with_labels=True, node_size=2, node_color='skyblue', font_size=8)
plt.title("Package Dependency Tree")

# Show the plot only if we are running in a Jupyter notebook
if "ipykernel_launcher.py" in sys.argv[0]:
    plt.show()