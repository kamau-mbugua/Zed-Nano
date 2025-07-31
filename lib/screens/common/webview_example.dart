import 'package:flutter/material.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/common/common_webview_page.dart';

/// Example showing how to use the CommonWebViewPage
class WebViewExample extends StatelessWidget {
  const WebViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'WebView Usage Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Example 1: Using AppRoutes helper method
            ElevatedButton(
              onPressed: () {
                AppRoutes.navigateToWebView(
                  context,
                  url: 'https://flutter.dev',
                  title: 'Flutter Documentation',
                  showAppBar: true,
                );
              },
              child: const Text('Open Flutter.dev (Using AppRoutes)'),
            ),
            
            const SizedBox(height: 10),
            
            // Example 2: Direct navigation
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommonWebViewPage(
                      url: 'https://github.com',
                      title: 'GitHub',
                      showAppBar: true,
                    ),
                  ),
                );
              },
              child: const Text('Open GitHub (Direct Navigation)'),
            ),
            
            const SizedBox(height: 10),
            
            // Example 3: WebView without app bar
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommonWebViewPage(
                      url: 'https://google.com',
                      showAppBar: false,
                    ),
                  ),
                );
              },
              child: const Text('Open Google (No App Bar)'),
            ),
            
            const SizedBox(height: 10),
            
            // Example 4: With custom callbacks
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommonWebViewPage(
                      url: 'https://example.com',
                      title: 'Example Site',
                      onPageFinished: () {
                        print('Page finished loading!');
                      },
                      onUrlChanged: (url) {
                        print('URL changed to: $url');
                      },
                      onBack: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('WebView closed')),
                        );
                      },
                    ),
                  ),
                );
              },
              child: const Text('Open with Callbacks'),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Usage Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            const Text(
              '1. Use AppRoutes.navigateToWebView() for simple navigation\n'
              '2. Use direct navigation for more control\n'
              '3. Set showAppBar to false for fullscreen experience\n'
              '4. Use callbacks for custom behavior',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
