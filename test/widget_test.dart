import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:axion_digital/constants/app_theme.dart';
import 'package:axion_digital/widgets/admin_login_dialog.dart';
import 'package:axion_digital/widgets/search_filters_bar.dart';
import 'package:axion_digital/widgets/app_header.dart';
import 'package:axion_digital/screens/admin_dashboard_screen.dart';

const List<int> _kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpRequest();
}

class _MockHttpRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _MockHttpResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  testWidgets('Admin Login Card renders all required fields and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: AdminLoginCard(isDialog: false),
          ),
        ),
      ),
    );

    expect(find.text('Axion Digital'), findsOneWidget);
    expect(find.text('تسجيل دخول المشرف'), findsOneWidget);
    expect(find.text('البريد الإلكتروني للمشرف'), findsOneWidget);
    expect(find.text('كلمة المرور'), findsOneWidget);
    expect(find.text('تذكرني على هذا الجهاز'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('Search Filters Bar renders deal tabs and 4 filter categories', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SearchFiltersBar(),
          ),
        ),
      ),
    );

    expect(find.text('عقارات للبيع'), findsOneWidget);
    expect(find.text('عقارات للإيجار'), findsOneWidget);
    expect(find.text('المحافظة'), findsOneWidget);
    expect(find.text('المنطقة أو الحي'), findsOneWidget);
    expect(find.text('النوع'), findsOneWidget);
    expect(find.text('نطاق السعر'), findsOneWidget);
    expect(find.text('بحث فوري عن العقارات المتاحة'), findsOneWidget);
  });

  testWidgets('AppHeader renders brand and support agent icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppHeader(),
          ),
        ),
      ),
    );

    expect(find.text('Axion Digital'), findsOneWidget);
    expect(find.byIcon(Icons.support_agent), findsOneWidget);
  });

  testWidgets('AdminDashboardScreen renders without RenderFlex overflow at 500px and 1200px', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: AdminDashboardScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Axion Digital CMS | الإدارة المركزية'), findsOneWidget);
    expect(find.text('نظرة عامة'), findsOneWidget);
    expect(find.text('قائمة العقارات'), findsOneWidget);
    expect(find.text('إجراءات سريعة'), findsOneWidget);

    // Test at 1200px width
    tester.view.physicalSize = const Size(1200, 900);
    await tester.pump();
    expect(find.text('Axion Digital CMS | الإدارة المركزية'), findsOneWidget);
  });
}
