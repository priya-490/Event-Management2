import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'add_event.dart';
import 'event_details.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String selectedCategory = 'All';
  String searchQuery = '';
  bool isGridView = true;
  String sortBy = 'Title';

  List<String> categories = ['All', 'Technology', 'Startup'];
  List<String> sortOptions = ['Title', 'Date'];

  List<Event> get filteredEvents {
    List<Event> filtered =
        events.where((event) {
          final matchCategory =
              selectedCategory == 'All' || event.category == selectedCategory;
          final matchSearch = event.title.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          return matchCategory && matchSearch;
        }).toList();

    if (sortBy == 'Title') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy == 'Date') {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    }

    return filtered;
  }

  void _confirmDelete(Event event) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Delete Event"),
            content: const Text("Are you sure you want to delete this event?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(ctx),
              ),
              TextButton(
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    events.remove(event);
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Events"),
        leading: const Icon(Icons.arrow_back),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search events...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    if (value != null) setState(() => selectedCategory = value);
                  },
                  items:
                      categories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: sortBy,
                  onChanged: (value) {
                    if (value != null) setState(() => sortBy = value);
                  },
                  items:
                      sortOptions
                          .map(
                            (opt) => DropdownMenuItem(
                              value: opt,
                              child: Text("Sort: $opt"),
                            ),
                          )
                          .toList(),
                ),
                IconButton(
                  icon: Icon(isGridView ? Icons.list : Icons.grid_view),
                  onPressed: () => setState(() => isGridView = !isGridView),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    "Total Events",
                    events.length.toString(),
                    isDark,
                  ),
                  _buildStatCard(
                    "Filtered Events",
                    filteredEvents.length.toString(),
                    isDark,
                  ),
                  _buildStatCard("Total Attendees", "1750+", isDark),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  filteredEvents.isEmpty
                      ? const Center(child: Text("No events found."))
                      : isGridView
                      ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.6,
                            ),
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          return EventCard(
                            event: filteredEvents[index],
                            onDelete: _confirmDelete,
                            onToggle: () {
                              setState(() {
                                filteredEvents[index].isActive =
                                    !filteredEvents[index].isActive;
                              });
                            },
                            isGridView: true,
                          );
                        },
                      )
                      : ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          return EventCard(
                            event: filteredEvents[index],
                            onDelete: _confirmDelete,
                            onToggle: () {
                              setState(() {
                                filteredEvents[index].isActive =
                                    !filteredEvents[index].isActive;
                              });
                            },
                            isGridView: false,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade300,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, bool isDark) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final void Function() onToggle;
  final void Function(Event) onDelete;
  final bool isGridView;

  const EventCard({
    super.key,
    required this.event,
    required this.onToggle,
    required this.onDelete,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isGridView ? 260 : 370,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                event.imagePath,
                height: isGridView ? 100 : 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.date,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Active:"),
                        Switch(
                          value: event.isActive,
                          onChanged: (_) => onToggle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EventDetailsPage(
                                        title: event.title,
                                        date: event.date,
                                        location: event.location,
                                        attendees: event.attendees,
                                        category: event.category,
                                        description: event.description,
                                        imagePath: event.imagePath,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline, size: 16),
                            label: const Text(
                              "Details",
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade100,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red,
                          ),
                          onPressed: () => onDelete(event),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final String date;
  final String location;
  final String attendees;
  final String category;
  final String description;
  final String imagePath;
  bool isActive;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.attendees,
    required this.category,
    required this.description,
    required this.imagePath,
    this.isActive = true,
  });
}

List<Event> events = [
  Event(
    title: "Tech Fest 2025",
    date: "March 20, 2025",
    location: "New York, USA",
    attendees: "1.2K",
    category: "Technology",
    description: "Join the biggest tech festival with top industry experts!",
    imagePath: "assets/event1.webp",
  ),
  Event(
    title: "Startup Conference",
    date: "April 5, 2025",
    location: "San Francisco, USA",
    attendees: "800",
    category: "Startup",
    description: "A gathering of brilliant minds in the startup world.",
    imagePath: "assets/event2.jpg",
  ),
];
