import networkx as nx  # Import the networkx library for graph operations
import matplotlib.pyplot as plt  # Import matplotlib for plotting graphs
import heapq  # Import heapq for priority queue operations used in Dijkstra's algorithm




class RoadNetwork:
   def __init__(self):
       self.graph = nx.DiGraph()  # Create a directed graph
       self.homes = []  # List to store home nodes
       self.intersections = []  # List to store intersection nodes


   def add_intersection(self, intersection_id):
       self.graph.add_node(intersection_id, type="intersection")  # Add an intersection node to the graph
       self.intersections.append(intersection_id)  # Append the intersection ID to the list of intersections


   def add_road(self, road_id, name, start, end, weight):
       self.add_intersection(start)  # Ensure the start intersection exists
       self.add_intersection(end)  # Ensure the end intersection exists
       # Add an edge representing the road between start and end intersections
       self.graph.add_edge(start, end, road_id=road_id, weight=weight, name=name)


   def add_home(self, home_id, intersection_id, distance):
       # Add a node for the home connected to an intersection
       self.graph.add_node(home_id, type="home", distance=distance, intersection=intersection_id)
       # Add an edge from the intersection to the home with a weight as the distance
       self.graph.add_edge(intersection_id, home_id, weight=distance)
       # Append the home details to the homes list
       self.homes.append({"home_id": home_id, "intersection_id": intersection_id, "distance": distance})


   def view_road_network(self):
       pos = nx.spring_layout(self.graph)  # Position nodes using the spring layout algorithm
       node_types = nx.get_node_attributes(self.graph, 'type')  # Get node types (intersection or home)
       # Filter nodes to separate intersections and homes
       intersection_nodes = [node for node, node_type in node_types.items() if node_type == "intersection"]
       home_nodes = [node for node, node_type in node_types.items() if node_type == "home"]
       # Draw nodes for intersections and homes with different colors
       nx.draw_networkx_nodes(self.graph, pos, nodelist=intersection_nodes, node_color="skyblue",
                              label="Intersections")
       nx.draw_networkx_nodes(self.graph, pos, nodelist=home_nodes, node_color="orange", label="Homes")
       # Draw edges and edge labels
       nx.draw_networkx_edges(self.graph, pos, edge_color='black', arrows=False, connectionstyle='arc3,rad=0.1')
       edge_labels = nx.get_edge_attributes(self.graph, 'weight')  # Get edge weights for labels
       nx.draw_networkx_edge_labels(self.graph, pos, edge_labels=edge_labels)  # Draw edge labels on the graph
       nx.draw_networkx_labels(self.graph, pos)  # Draw labels for nodes
       plt.title("Road Network Graph")  # Title for the graph
       plt.show()  # Display the graph


   def find_shortest_path(self, start, end):
       # Find the shortest path from start to end using Dijkstra's algorithm
       path = nx.shortest_path(self.graph, source=start, target=end, weight='weight')
       # Find the shortest path length from start to end
       path_length = nx.shortest_path_length(self.graph, source=start, target=end, weight='weight')
       return path, path_length


   def dijkstra_shortest_path(self, source_intersection):
       shortest_paths = {}  # Dictionary to store shortest path lengths
       queue = [(0, source_intersection)]  # Priority queue for Dijkstra's algorithm
       visited = set()  # Set to track visited nodes


       while queue:
           distance, current_intersection = heapq.heappop(queue)  # Get the node with the smallest distance
           if current_intersection in visited:
               continue  # Skip this node if it has been visited
           visited.add(current_intersection)  # Mark this node as visited
           shortest_paths[current_intersection] = distance  # Store the shortest path length to this node
           # Iterate over neighbors of the current node
           for neighbor in self.graph.neighbors(current_intersection):
               if neighbor not in visited:
                   neighbor_distance = distance + self.graph[current_intersection][neighbor]['weight']
                   heapq.heappush(queue, (neighbor_distance, neighbor))  # Add neighbor to the priority queue
       return shortest_paths


   def print_all_homes(self):
       for home in self.homes:  # Print details of all homes in the graph
           print(
               f"Home ID: {home['home_id']}, Intersection ID: {home['intersection_id']}, Distance: {home['distance']}")




# Example road network setup
road_network = RoadNetwork()
road_network.add_road(1, "Road 1", "A", "B", 5)
road_network.add_road(2, "Road 2", "A", "C", 3)
road_network.add_road(3, "Road 3", "C", "B", 2)
road_network.add_road(4, "Road 4", "B", "D", 4)
road_network.add_road(5, "Road 5", "C", "E", 6)
road_network.add_road(6, "Road 6", "E", "D", 1)
road_network.add_road(7, "Road 7", "D", "F", 2)
road_network.add_road(8, "Road 8", "E", "F", 3)


road_network.add_home("H1", "B", 1)
road_network.add_home("H2", "E", 3)
road_network.add_home("H3", "D", 2)
road_network.add_home("H4", "C", 4)




# Interactive menu implementation
def menu(road_network):
   print("Welcome to the City Road Network System")
   print(
       "This system represents the city's road network as a graph, where intersections are nodes and roads are edges.")
   print("Edges have weights representing average travel times or congestion levels.")


   while True:
       print("\n City Road Network System MENU ")
       print("1. View the road network")
       print("2. View the list of intersections and homes")
       print("3. Distribute packages from a source intersection")
       print("4. Find the shortest path between two intersections")
       print("5. Exit")


       choice = input("Enter your choice (1-5): ")
       if choice == '1':
           road_network.view_road_network()
       elif choice == '2':
           print("Intersections:", road_network.intersections)
           road_network.print_all_homes()
       elif choice == '3':
           source = input("Enter the source intersection: ")
           if source not in road_network.intersections:
               print("Invalid intersection. Please enter a valid intersection ID.")
               continue
           print("Distributing packages...")
           distances = road_network.dijkstra_shortest_path(source)
           print(f"Shortest paths from {source}: {distances}")
       elif choice == '4':
           print("Available Intersections:", road_network.intersections)
           start = input("Enter the start intersection: ")
           end = input("Enter the end intersection: ")
           if start not in road_network.intersections or end not in road_network.intersections:
               print("Invalid intersection. Please enter valid intersection IDs.")
               continue
           path, path_length = road_network.find_shortest_path(start, end)
           print(f"Shortest path from {start} to {end}: {path} with length {path_length}")
       elif choice == '5':
           print("thank you, exiting City Road Network System ")
           break
       else:
           print("Invalid choice. Please enter a number between 1 and 5.")




if __name__ == "__main__":
   menu(road_network)
