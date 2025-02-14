import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicalarm/utils/local_notification/client.dart';

class LocalNotifications extends StatelessWidget {
  const LocalNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Local Notifications'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LocalNotificationsPage()));
      },
    );
  }
}

class LocalNotificationsPage extends HookWidget {
  const LocalNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingLocalNotifications = useState<List<PendingNotificationRequest>>([]);
    useEffect(() {
      void f() async {
        pendingLocalNotifications.value = await localNotificationService.pendingReminderNotifications();
      }

      f();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final pendingNotification = pendingLocalNotifications.value[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pendingNotification.id.toString()),
                Text('title: ${pendingNotification.title ?? ''}'),
                Text('body: ${pendingNotification.body ?? ''}'),
                Text('payload: ${pendingNotification.payload ?? ''}'),
                const Divider(),
              ],
            ),
          );
        },
        itemCount: pendingLocalNotifications.value.length,
      ),
    );
  }
}
