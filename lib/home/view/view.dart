import 'package:crsewms/home/order/order.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        key: Key('in-completed-orders'),
        isOrderDelivered: true,
        label: 'History',
      ),
    );

    _widgetOptions.add(
      Container(
        alignment: Alignment.center,
        child: Text('3'),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                color: _selectedIndex == 0 ? Color(0xFFff8b54) : Colors.grey,
                icon: Icon(
                  Icons.home,
                  size: _selectedIndex == 0 ? 30.0 : 24.0,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                color: _selectedIndex == 1 ? Color(0xFFff8b54) : Colors.grey,
                icon: Icon(
                  Icons.assignment,
                  size: _selectedIndex == 1 ? 30.0 : 24.0,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                color: _selectedIndex == 2 ? Color(0xFFff8b54) : Colors.grey,
                icon: Icon(
                  Icons.assignment,
                  size: _selectedIndex == 2 ? 30.0 : 24.0,
                ),
                onPressed: () => _onItemTapped(2),
              ),
            ],
          )),
    );
  }
}
