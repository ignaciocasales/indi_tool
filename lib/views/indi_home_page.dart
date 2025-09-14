import 'package:flutter/material.dart';
import 'package:indi_tool/components/indi_app_bar.dart';
import 'package:indi_tool/models/test_case.dart';
import 'package:indi_tool/views/test_detail_page.dart';

class IndiHomePage extends StatefulWidget {
  const IndiHomePage({super.key});

  @override
  State<IndiHomePage> createState() => _IndiHomePageState();
}

class _IndiHomePageState extends State<IndiHomePage> {
  bool _collapsed = false;
  int _nextId = 3;
  final List<TestCase> _tests = const [
    TestCase(id: 1, name: 'Test 1', method: 'GET', url: 'https://jsonplaceholder.typicode.com/posts', resultCount: 3),
    TestCase(id: 2, name: 'Test 2', method: 'GET', url: 'https://jsonplaceholder.typicode.com/posts', resultCount: 0),
  ].toList();

  void _toggleSidebar() {
    setState(() => _collapsed = !_collapsed);
  }

  void _createNewTest() {
    final test = TestCase(
      id: _nextId++,
      name: 'Test ${_nextId - 1}',
      method: 'GET',
      url: 'https://example.com/api',
      resultCount: 0,
    );
    setState(() => _tests.add(test));
    _openTest(test);
  }

  void _openTest(TestCase test) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TestDetailPage(test: test),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: indiAppBar(context: context),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _collapsed ? 56 : 280,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _collapsed ? 0 : 12, vertical: 8),
                  child: Row(
                    children: [
                      if (!_collapsed)
                        Expanded(
                          child: Text(
                            'Tests',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      IconButton(
                        tooltip: _collapsed ? 'Expand' : 'Collapse',
                        onPressed: _toggleSidebar,
                        icon: Icon(_collapsed ? Icons.chevron_right : Icons.chevron_left),
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      ),
                    ],
                  ),
                ),
                if (!_collapsed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _createNewTest,
                        icon: const Icon(Icons.add),
                        label: const Text('New Test'),
                      ),
                    ),
                  ),
                if (!_collapsed) const SizedBox(height: 8),
                if (!_collapsed)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final t = _tests[index];
                        return _collapsed
                            ? IconButton(
                                tooltip: t.name,
                                onPressed: () => _openTest(t),
                                icon: const Icon(Icons.article_outlined),
                              )
                            : InkWell(
                                onTap: () => _openTest(t),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Theme.of(context).dividerColor),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              color: Theme.of(context).colorScheme.surfaceVariant,
                                            ),
                                            child: Text(
                                              t.method,
                                              style: Theme.of(context).textTheme.labelSmall,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              '${t.resultCount} results',
                                              style: Theme.of(context).textTheme.labelSmall,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(t.name, style: Theme.of(context).textTheme.titleSmall),
                                      Text(t.url, style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                              );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemCount: _tests.length,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Load Testing Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create a new test or select an existing one to get started',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _createNewTest,
                      child: const Text('Create New Test'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
