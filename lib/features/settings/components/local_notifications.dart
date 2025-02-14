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
        Navigator.push(context, MaterialPageRoute(builder: (context) => LocalNotificationsPage()));
      },
    );
  }
}

class LocalNotificationsPage extends HookWidget {
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

    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(pendingLocalNotifications.value[index].id.toString());
      },
      itemCount: pendingLocalNotifications.value.length,
    );
  }
}
