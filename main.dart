import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Main
void main() {
  runApp(DividendCalculatorApp());
}

// Main app widget
class DividendCalculatorApp extends StatelessWidget {
  const DividendCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Trust Dividend Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF0F4F8),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}

// Main screen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  // List of pages
  final List<Widget> pages = [
    HomePage(),
    AboutPage(),
  ];

  // Function to handle bottom navigation bar
  void onBottomNavTap(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar at the top
      appBar: AppBar(
        title: Text('Unit Trust Dividend Calculator'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      // Show current page based on selected index
      body: pages[currentPageIndex],
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF0F4F8),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.blue[700],
        onTap: onBottomNavTap,
      ),
    );
  }
}

// Calculate dividends
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final investedAmountController = TextEditingController();
  final dividendRateController = TextEditingController();
  final monthsController = TextEditingController();

  // Variables to store calculation results
  double monthlyDividend = 0.0;
  double totalDividend = 0.0;
  bool showResults = false; // Whether to show results or not

  // Function to calculate dividend
  void calculateDividend() {
    // Check if form is valid before calculating
    if (formKey.currentState!.validate()) {
      // Get values from text fields and convert to numbers
      double investedAmount = double.parse(investedAmountController.text);
      double dividendRate = double.parse(dividendRateController.text);
      int months = int.parse(monthsController.text);

      // Calculate monthly dividend
      monthlyDividend = (dividendRate / 100 / 12) * investedAmount;

      // Calculate total dividend
      totalDividend = monthlyDividend * months;

      // Update UI to show results
      setState(() {
        showResults = true;
      });
    }
  }

  // Function to reset form
  void resetForm() {
    investedAmountController.clear();
    dividendRateController.clear();
    monthsController.clear();

    // Reset variables and hide results
    setState(() {
      showResults = false;
      monthlyDividend = 0.0;
      totalDividend = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input form card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Text(
                      'Investment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Invested amount input
                    TextFormField(
                      controller: investedAmountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Invested Fund Amount (RM)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter invested amount';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Please enter a valid positive amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Dividend rate input
                    TextFormField(
                      controller: dividendRateController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Annual Dividend Rate (%)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.percent),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter dividend rate';
                        }
                        if (double.tryParse(value) == null || double.parse(value) < 0) {
                          return 'Please enter a valid rate';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Number of months input
                    TextFormField(
                      controller: monthsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Number of Months Invested (Max 12)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of months';
                        }
                        int? months = int.tryParse(value);
                        if (months == null || months < 1 || months > 12) {
                          return 'Please enter a valid number between 1-12';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Calculate and Reset buttons
            Row(
              children: [
                // Calculate button
                Expanded(
                  child: ElevatedButton(
                    onPressed: calculateDividend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Calculate Dividend',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Reset button
                Expanded(
                  child: ElevatedButton(
                    onPressed: resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),

            // Results section
            if (showResults) ...[
              SizedBox(height: 20),
              Card(
                elevation: 4,
                color: Colors.green[50],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Results title
                      Text(
                        'Calculation Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Results container
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Column(
                          children: [
                            // Monthly dividend display
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monthly Dividend:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'RM ${monthlyDividend.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 20),
                            // Total dividend display
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Dividend:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'RM ${totalDividend.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// About page with app and author information
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // App info card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // App icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.calculate,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // App title
                  Text(
                    'Unit Trust Dividend Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  // App version
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Author information card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Author Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 12),
                  buildInfoRow(Icons.person, 'Name: ', 'ARIESSA NUR AIN BINTI ABU ZAHRI'),
                  buildInfoRow(Icons.school, 'Matric No:', '2023135733'),
                  buildInfoRow(Icons.book, 'Course:', 'MOBILE TECHNOLOGY AND DEVELOPMENT'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Project information card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'This application calculates dividend returns from unit trust investments based on invested amount, annual dividend rate, and investment period.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  // GitHub Repo
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse('https://github.com/heiyuezi/divcalc');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch URL')),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.code, color: Colors.blue[700]),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GitHub Repository',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  'Tap to view source code',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.open_in_new, color: Colors.blue[700]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Copyright notice card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Copyright Notice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '© 2025 Arie. All rights reserved.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This application is developed as part of the Mobile Technology and Development course assignment.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build info rows in about page
  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}