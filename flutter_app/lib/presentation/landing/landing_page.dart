import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/sensem_action_listener.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:provider/provider.dart';
import 'package:domain/use_case/mark_landing_page_as_seen_uc.dart';
import 'landing_bloc.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({@required this.bloc}) : assert(bloc != null);
  final LandingBloc bloc;

  static Widget create() => ProxyProvider<MarkLandingPageAsSeenUC, LandingBloc>(
        update: (context, markLandingPageAsSeenUC, _) =>
            LandingBloc(markLandingPageAsSeenUC: markLandingPageAsSeenUC),
        dispose: (context, bloc) => bloc.dispose,
        child: Consumer<LandingBloc>(
          builder: (context, bloc, _) => LandingPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final CarouselController _carouselController = CarouselController();
  final List _imgList = [
    'images/img_notification.png',
    'images/img_tasklist.png',
    'images/img_notebadge.png',
  ];

  int _current = 0;
  List _titleTextList;
  List _descriptionTextList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _descriptionTextList = [
      S.of(context).sensem_description,
      S.of(context).tasks_description,
      S.of(context).notifications_description,
    ];

    _titleTextList = [
      S.of(context).sensem_title,
      S.of(context).tasks_title,
      S.of(context).notifications_title,
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SensemActionListener(
          actionStream: widget.bloc.onActionEvent,
          onReceived: (event) {
            Navigator.pushReplacementNamed(context, 'login');
          },
          child: Container(
            color: SenSemColors.primaryColor,
            child: SafeArea(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CarouselSlider(
                        items: _imgList
                            .asMap()
                            .map(
                              (index, _) => MapEntry(
                                index,
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          child: Image.asset(_imgList[index])),
                                      Text(
                                        _titleTextList[index],
                                        style: TextStyle(
                                          color: SenSemColors.mediumGray,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        _descriptionTextList[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: SenSemColors.mediumGray,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: false,
                          enableInfiniteScroll: false,
                          aspectRatio: 0.8,
                          viewportFraction: 1,
                          onPageChanged: (index, _) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        carouselController: _carouselController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _imgList.length,
                          (index) {
                            final size = _current == index ? 10.0 : 8.0;

                            return Container(
                              width: size,
                              height: size,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? SenSemColors.aquaGreen
                                    : Colors.grey,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.transparent,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, .5),
                                  )
                                ],
                              ),
                            );
                          },
                          growable: false,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          if (_current == 2) {
                            widget.bloc.onMarkLandingPageAsSeen.add(null);
                          }
                          setState(() {
                            if (_current != 2) {
                              _current++;
                              _carouselController.jumpToPage(_current);
                            }
                          });
                        },
                        color: SenSemColors.aquaGreen,
                        child: Text(
                          _current != 2
                              ? S.of(context).got_it_title
                              : S.of(context).begin_title,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
