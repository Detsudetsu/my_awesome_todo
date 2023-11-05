import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('リスト一覧')),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index]),
              trailing: Wrap(children: [
                IconButton(
                  onPressed: () async {
                    final newname =
                        await _renameDialogBuilder(context, todoList[index]);
                    if (newname != null) {
                      setState(() {
                        todoList[index] = newname;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    final result = await _deleteDialogBuilder(context);
                    if (result == null || !result) {
                      return;
                    }
                    setState(() {
                      todoList.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const TodoAddPage();
            }),
          );
          if (newListText != null) {
            setState(() {
              todoList.add(newListText);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _deleteDialogBuilder(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスク削除'),
        content: const Text('タスクを完全に削除します'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('実行'),
          ),
        ],
      ),
    );
  }

  Future<String?> _renameDialogBuilder(BuildContext context, String oldname) {
    String newname = oldname;

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスク名変更'),
        content: TextFormField(
          initialValue: oldname,
          onChanged: (value) {
            newname = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(newname);
            },
            child: const Text('変更'),
          ),
        ],
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  State<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リスト追加'),
      ),
      body: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_text),
            const SizedBox(height: 8),
            TextField(
              onChanged: (String value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_text);
                },
                child: const Text(
                  'リスト追加',
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('キャンセル'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
