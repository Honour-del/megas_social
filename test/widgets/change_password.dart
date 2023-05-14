// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';
import 'package:megas/core/utils/custom_widgets/text_fields.dart';
import 'package:megas/src/views/login/component/forgot_password/change_password.dart';
import 'package:megas/src/views/login/login_page.dart';



// @flutter_test
void main() {
  Widget createWidget({Widget? widget}){
    return ScreenUtilInit(
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
          home: widget,
        );
      },
    );
  }

  testWidgets('change_password page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    //   final widget = FeedPage();
    await tester.pumpWidget(createWidget(widget: ChangePassword()));
    //// this also works
    //   await tester.pumpWidget(ScreenUtilInit(builder: (BuildContext context, child){
    //     return MaterialApp(
    //       home: FeedPage(),
    //     );
    //   }));

    // expect(find.byType(ConsumerStatefulWidget, skipOffstage: false), findsOneWidget);
    expect(find.byType(Form, skipOffstage: false), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Column, skipOffstage: false), findsWidgets);
    // expect(find.text("Welcome back "), findsOneWidget);
    // expect(find.text("Email"), findsOneWidget);
    // expect(find.text("Login to continue!"), findsOneWidget);
    expect(find.byType(Image, skipOffstage: false), findsOneWidget);
    expect(find.byType(GestureDetector, skipOffstage: false), findsWidgets);
    expect(find.byType(TextFormField, skipOffstage: false), findsWidgets);
    expect(find.byType(FlatButton, skipOffstage: false), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), "abcdefgh");
    await tester.enterText(find.byType(TextFormField).at(1), "abcdefgh");
    await tester.tap(find.byType(FlatButton));
    expect(find.text("Must contain atleast 1 uppercase letter"), findsOneWidget);
    // await tester.tap(find.byIcon(Icons.menu));
    // await tester.pump();
    // // expect(find.byKey(draw), findsOneWidget);
    // expect(find.byType(DrawerView), findsOneWidget);
    // debugDumpRenderTree();
    // expect(find.byType(FeedPage), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(fin, findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
