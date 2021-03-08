import 'package:flutter/material.dart';
import 'package:kaffebotapp/Services/api_service.dart';
import 'package:kaffebotapp/statistic_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  bool _isLoading = false;
  static bool _reminderTask = false;
  String municipalityName = "";
  ApiService apiService = ApiService();
  double _sliderValue = 50;
  Animation numberAnimation;


  @override
  void initState() {
    setState(() {
      numberAnimation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(
          parent: widget.animationController,
          curve:
          Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    });
    //_isLoading = true;
    //getMunicipalityName();
    getReminderTask();
    //getNumberOfPins();
    super.initState();
  }

  Future<void> getMunicipalityName() async {
    setState(() {
      _isLoading = false;
    });
    return;
  }

  Future<void> getReminderTask() async {
    setState(() {
    });
  }

  Future<void> getNumberOfPins() async {
    setState(() {
    });
  }

  void showConfirmation() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Er du sikker?"),
            content: Text("Bekræft venligst om du vil logge af."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Annuler"),
              ),
              FlatButton(
                onPressed: () {
                  logOut();
                },
                child: Text(
                  "Log af",
                ),
              )
            ],
          );
        });
  }

  Future<void> logOut() async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/landing', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height < 600 ? 40 : 60,
                  width: double.infinity,
                  child: Container(color: Colors.white)),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                width: double.infinity,
                padding: EdgeInsets.only(left: 16, bottom: 22),
                child: Text("wee",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36),
                ),
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: profileBody(),
                    ),
            ],
          ),
        ));
  }

/*

 */
  Widget profileBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        municipalityName.isEmpty
            ? Container(
                height: 0,
              )
            : Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Du er logget på ' + municipalityName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
        reminderTaskSwitchButton(),
        maxPinsSlider(),
        Padding(
          child: appointmentStatisticsBody(),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        Padding(
          child: taskStatisticsBody(),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        Padding(
          padding: EdgeInsets.only(top: 32, bottom: 32),
          child: Center(
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  showConfirmation();
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 3.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Log af',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget maxPinsSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Brug slideren til at definere hvor mange virksomheder du vil fremsøge i kortet",
            ),
          ),
          Slider(
            value: _sliderValue,
            min: 50,
            max: 500,
            divisions: 9,
            label: _sliderValue.toInt().toString(),
            onChangeEnd: (value) async {
            },
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Antal virksomheder:',
                ),
                Text(
                  _sliderValue.toInt().toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16)
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget reminderTaskSwitchButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Spørg om opfølgningsopgave ved oprettelse af notat ud fra aftale",
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Switch(
            value: _reminderTask,
            onChanged: (value) async {
              setState(() {
                _reminderTask = !_reminderTask;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget appointmentStatisticsTitle() {}

  Widget appointmentStatisticsBody() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          widget.animationController.forward();
          return StatisticView(
            animation: numberAnimation,
            animationController: widget.animationController,
            closedInViktor: "Lukkede aftaler fra fasit",
            completedTasksNumber: 12,
            closedInFasit: "Lukkede aftaler fra viktor",
            remainingTasksNumber: 4,
            image: "assets/appointmentsMenuSelected.png",
          );
        }
      },
    );
  }

  Widget taskStatisticsBody() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          widget.animationController.forward();
          return StatisticView(
            animation: numberAnimation,
            animationController: widget.animationController,
            closedInViktor: "Lukkede opgaver fra fasit",
            completedTasksNumber: 8,
            closedInFasit: "Lukkede opgaver fra viktor",
            remainingTasksNumber: 6,
            image: "assets/tasksMenuSelected.png",
          );
        }
      },
    );
  }
}

Future<bool> getData() async {
  await Future<dynamic>.delayed(const Duration(milliseconds: 50));
  return true;
}