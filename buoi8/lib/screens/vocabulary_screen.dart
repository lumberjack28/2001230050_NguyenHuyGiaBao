import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/notifications.dart';
import '../models/vocabulary_word.dart';
import '../services/vocabulary_file.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  final wordController = TextEditingController();
  final meaningController = TextEditingController();
  final file = VocabularyFile();
  List<VocabularyWord> words = [];
  bool saving = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    try {
      final data = await file.load();
      if (mounted) setState(() => words = data);
    } catch (e) {
      notifyUser('Loi doc tu vung: $e');
    }
  }

  void notifyUser(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> saveWord() async {
    final word = wordController.text.trim();
    final meaning = meaningController.text.trim();
    if (word.isEmpty || meaning.isEmpty) {
      notifyUser('Nhap du tu va nghia');
      return;
    }
    setState(() => saving = true);
    final record = VocabularyWord(
      id: Notifications.newId(),
      word: word,
      meaning: meaning,
      due: DateTime.now().add(const Duration(minutes: 10)),
    );
    try {
      final updated = [...words, record];
      await file.save(updated);
      if (!mounted) return;
      setState(() {
        words = updated;
        wordController.clear();
        meaningController.clear();
      });
      await Notifications.instance.show(
        'Da luu tu vung',
        'Hay on tap tu $word sau 10 phut',
        channel: 'vocab',
      );
      await Notifications.instance.schedule(
        id: record.id,
        title: 'On tap tu vung',
        message: 'Hay on tap: $word - $meaning',
        when: record.due,
        channel: 'vocab',
        payload: 'vocab:${record.id}',
      );
      notifyUser('Da luu va hen lich hoc tu sau 10 phut');
    } catch (e) {
      notifyUser('Da luu tu, nhung co loi notification: $e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  void go(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  void dispose() {
    wordController.dispose();
    meaningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ung dung hoc tu vung')),
      drawer: Drawer(
        child: ListView(children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Tro ly hoc tu vung'),
            accountEmail: Text('Bai tap 4 tren lop'),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.school)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chinh'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Hoc tu'),
            onTap: () => go(StudyWordsScreen(words: words)),
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Kiem tra tu'),
            onTap: () => go(TrueFalseScreen(words: words)),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Lich nhac'),
            onTap: () => go(const VocabularyRemindersScreen()),
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: wordController,
            decoration: const InputDecoration(labelText: 'Tu'),
          ),
          TextField(
            controller: meaningController,
            decoration: const InputDecoration(labelText: 'Nghia'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: saving ? null : saveWord,
            child: const Text('Luu & Nhac hoc sau 10 phut'),
          ),
          const SizedBox(height: 12),
          Text('Da luu ${words.length} tu vung'),
        ]),
      ),
    );
  }
}

class StudyWordsScreen extends StatefulWidget {
  final List<VocabularyWord> words;
  const StudyWordsScreen({super.key, required this.words});

  @override
  State<StudyWordsScreen> createState() => _StudyWordsScreenState();
}

class _StudyWordsScreenState extends State<StudyWordsScreen> {
  final controller = TextEditingController();
  int index = 0;
  int correct = 0;
  int wrong = 0;

  Future<void> check() async {
    if (widget.words.isEmpty || controller.text.trim().isEmpty) return;
    final item = widget.words[index % widget.words.length];
    final ok = controller.text.trim().toLowerCase() ==
        item.meaning.trim().toLowerCase();
    setState(() {
      if (ok) {
        correct++;
      } else {
        wrong++;
      }
      index++;
      controller.clear();
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Chinh xac!' : 'Sai! Dap an: ${item.meaning}'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    if (!ok && wrong % 3 == 0) {
      await Notifications.instance.show(
        'Hay on tap lai nhe!',
        'Ban da tra loi sai $wrong lan',
        channel: 'vocab',
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.words.isEmpty
        ? null
        : widget.words[index % widget.words.length];
    return Scaffold(
      appBar: AppBar(title: const Text('On tap tu moi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Chip(label: Text('Dung: $correct'), backgroundColor: Colors.green.shade200),
              Chip(label: Text('Sai: $wrong'), backgroundColor: Colors.orange.shade200),
            ]),
            const SizedBox(height: 20),
            if (current == null)
              const Text('Chua co tu vung. Hay them tu o trang chinh.')
            else
              Card(
                color: Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Text(current.word, style: Theme.of(context).textTheme.titleLarge),
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Nhap nghia tieng Viet'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: check, child: const Text('Check')),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class TrueFalseScreen extends StatefulWidget {
  final List<VocabularyWord> words;
  const TrueFalseScreen({super.key, required this.words});

  @override
  State<TrueFalseScreen> createState() => _TrueFalseScreenState();
}

class _TrueFalseScreenState extends State<TrueFalseScreen> {
  final random = Random();
  static const total = 10;
  int question = 0;
  int correct = 0;
  int wrong = 0;
  VocabularyWord? word;
  String displayedMeaning = '';
  bool isMatching = true;

  @override
  void initState() {
    super.initState();
    nextQuestion();
  }

  void nextQuestion() {
    final list = widget.words;
    if (list.isEmpty) return;
    word = list[random.nextInt(list.length)];
    final different = list.where((w) => w.meaning.toLowerCase() != word!.meaning.toLowerCase()).toList();
    isMatching = different.isEmpty || random.nextBool();
    displayedMeaning = isMatching
        ? word!.meaning
        : different[random.nextInt(different.length)].meaning;
  }

  Future<void> answer(bool userSaysTrue) async {
    final correctAnswer = userSaysTrue == isMatching;
    setState(() {
      if (correctAnswer) {
        correct++;
      } else {
        wrong++;
      }
      question++;
      if (question < total) nextQuestion();
    });
    if (question >= total) {
      final percent = (correct / total * 100).toStringAsFixed(0);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Ket thuc bai kiem tra'),
          content: Text('Dung: $correct\nSai: $wrong\nTi le dung: $percent%'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Thoat'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  question = 0;
                  correct = 0;
                  wrong = 0;
                  nextQuestion();
                });
              },
              child: const Text('Lam lai'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canQuiz = widget.words.length >= 2 &&
        widget.words.map((w) => w.meaning.toLowerCase()).toSet().length >= 2;
    return Scaffold(
      appBar: AppBar(title: const Text('Trac nghiem Dung / Sai')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: canQuiz
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Cau ${question + 1}/$total'),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Chip(label: Text('Dung: $correct')),
                    Chip(label: Text('Sai: $wrong')),
                  ]),
                  const SizedBox(height: 40),
                  Text(word?.word ?? '', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(displayedMeaning, style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    FilledButton.icon(
                      onPressed: () => answer(true),
                      icon: const Icon(Icons.check),
                      label: const Text('Dung'),
                    ),
                    FilledButton.icon(
                      onPressed: () => answer(false),
                      icon: const Icon(Icons.close),
                      label: const Text('Sai'),
                    ),
                  ]),
                ])
              : const Text('Can it nhat 2 tu co nghia khac nhau de lam trac nghiem.'),
        ),
      ),
    );
  }
}

class VocabularyRemindersScreen extends StatefulWidget {
  const VocabularyRemindersScreen({super.key});

  @override
  State<VocabularyRemindersScreen> createState() => _VocabularyRemindersScreenState();
}

class _VocabularyRemindersScreenState extends State<VocabularyRemindersScreen> {
  List<dynamic> reminders = [];
  Map<int, VocabularyWord> byId = {};

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final requests = await Notifications.instance.pendingVocabulary();
    final words = await VocabularyFile().load();
    if (!mounted) return;
    setState(() {
      reminders = requests;
      byId = {for (final word in words) word.id: word};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lich nhac')),
      body: reminders.isEmpty
          ? const Center(child: Text('Khong co lich nhac dang cho'))
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final request = reminders[index];
                final word = byId[request.id];
                final due = word == null
                    ? 'Dang cho thong bao'
                    : DateFormat('dd/MM/yyyy HH:mm').format(word.due);
                return ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(word == null ? (request.title ?? 'On tu') : 'On tu: ${word.word}'),
                  subtitle: Text(due),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () async {
                      await Notifications.instance.cancel(request.id);
                      await refresh();
                    },
                  ),
                );
              },
            ),
    );
  }
}
