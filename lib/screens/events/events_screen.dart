import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_stack/image_stack.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:tevo/models/event_model.dart' as eve;

import 'package:tevo/repositories/event/event_repository.dart';
import 'package:tevo/screens/events/create_screen.dart';
import 'package:tevo/screens/events/event_room_screen.dart';
import 'package:tevo/utils/theme_constants.dart';

import 'bloc/event_bloc.dart';

class EventsScreen extends StatefulWidget {
  static const routeName = 'events';

  EventsScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: BlocProvider<EventBloc>(
        create: (context) =>
            EventBloc(eventRepository: context.read<EventRepository>()),
        child: EventsScreen(),
      ),
    );
  }

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    context.read<EventBloc>().add(GetUserEvent());
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            overlayColor: Colors.black,
            iconTheme: IconThemeData(color: kPrimaryWhiteColor),
            foregroundColor: Colors.black,
            backgroundColor: kPrimaryBlackColor,
            children: [
              SpeedDialChild(
                label: 'Create',
                labelStyle: TextStyle(fontSize: 11.sp),
                backgroundColor: kPrimaryBlackColor,
                onTap: () {
                  Navigator.of(context).pushNamed(CreateEventScreen.routeName);
                },
              ),
              SpeedDialChild(
                label: 'Join',
                backgroundColor: Colors.amberAccent,
                labelStyle: TextStyle(fontSize: 11.sp),
                onTap: () {
                  showDialog(
                    context: context,
                    useSafeArea: true,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Join Event",
                        style: TextStyle(
                            fontSize: 14.sp, color: kPrimaryBlackColor),
                        textAlign: TextAlign.center,
                      ),
                      content: OTPTextField(
                        length: 6,
                      ),
                      actions: [
                        OutlinedButton(
                            onPressed: () {},
                            child: Text(
                              'Join',
                              style: TextStyle(color: kPrimaryBlackColor),
                            ))
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: state.status == EventStatus.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      controller: _controller,
                      clipBehavior: Clip.none,
                      headerSliverBuilder: (_, __) {
                        return [_buildAppBar()];
                      },
                      body: TabBarView(
                        children: [
                          _buildDashBoard(state),
                          _buildCompleted(),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      backgroundColor: kPrimaryWhiteColor,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      pinned: true,
      elevation: 1,
      toolbarHeight: 8.h,
      title: Text(
        "Events",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: kFontFamily,
          fontSize: 22.sp,
        ),
      ),
      bottom: TabBar(indicatorColor: kPrimaryBlackColor, tabs: [
        Tab(
          child: Text(
            "DashBoard",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 13.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Completed",
            style: TextStyle(
              color: kPrimaryBlackColor,
              fontSize: 13.sp,
              fontFamily: kFontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "COINS ICON",
            style: TextStyle(color: kPrimaryBlackColor),
          ),
        )
      ],
    );
  }

  List<String> images = [
    "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
    "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=487",
    "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg",
    "https://cxl.com/wp-content/uploads/2016/03/nate_munger.png"
  ];

  _buildDashBoard(EventState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "You can now create your own events or participate in the ongoing event to win your boons and get your reward ! Click on the ‘+’ to create an event...",
            style: TextStyle(
              fontSize: 9.sp,
              color: kPrimaryBlackColor.withOpacity(0.4),
            ),
            textAlign: TextAlign.justify,
          ),
          state.events == null || state.events!.isEmpty
              ? Container()
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: EventCardWidget(
                          images: images,
                          event: state.events![index],
                        ),
                      )),
                  itemCount: state.events!.length,
                ),
        ],
      ),
    );
  }

  _buildCompleted() {
    return Container();
  }
}

class EventCardWidget extends StatelessWidget {
  final List<String> images;
  final eve.Event event;

  const EventCardWidget({
    Key? key,
    required this.images,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(EventRoomScreen.routeName);
      },
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: kPrimaryBlackColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.eventName,
                    style: TextStyle(
                        color: kPrimaryBlackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "97 days",
                    style: TextStyle(
                        color: kPrimaryBlackColor.withOpacity(0.8),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Participants",
                    style: TextStyle(
                        color: kPrimaryBlackColor.withOpacity(0.5),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Rank: 17",
                    style: TextStyle(
                        color: kPrimaryBlackColor.withOpacity(0.5),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageStack(
                    imageList: images,
                    totalCount: images.length,
                    imageRadius: 22.sp,
                    imageCount: 3,
                    imageBorderWidth: 0,
                  ),
                  Row(
                    children: [
                      Text(
                        "2000",
                        style: TextStyle(
                            color: kPrimaryBlackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 4),
                      Image.network(
                        "https://cdn-icons-png.flaticon.com/512/1369/1369897.png",
                        scale: 20,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
