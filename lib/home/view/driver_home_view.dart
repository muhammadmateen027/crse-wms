import 'package:crsewms/home/order/order.dart';
import 'package:flutter/material.dart';

class DriverHomePage extends StatefulWidget {
  DriverHomePage({Key key}) : super(key: key);

  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = new List<Widget>();

  @override
  void initState() {
    super.initState();
    _buildScreens(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _buildScreens(BuildContext context) {
    _widgetOptions.add(
      new OrderList(
        key: Key('in-completed-orders'),
        isOrderDelivered: false,
        label: 'Available',
      ),
    );
    _widgetOptions.add(
      new OrderList(
        key: Key('in-history-orders'),
        isOrderDelivered: true,
        label: 'History',
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _navigationDrawer,
    );
  }

  Widget get _navigationDrawer {
    return Container(
      height: 60.0,
      child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  color: _selectedIndex == 0 ? Color(0xFFff8b54) : Colors.grey,
                  icon: Icon(
                    Icons.list,
                    size: _selectedIndex == 0 ? 30.0 : 24.0,
                  ),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  color: _selectedIndex == 1 ? Color(0xFFff8b54) : Colors.grey,
                  icon: Icon(
                    Icons.history,
                    size: _selectedIndex == 1 ? 30.0 : 24.0,
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
              ],
            ),
          )),
    );
  }
}
