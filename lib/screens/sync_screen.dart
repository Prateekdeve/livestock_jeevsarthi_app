import 'package:flutter/material.dart';
import '../core/app_config.dart';
import '../core/app_theme.dart';
import '../data/sync/sync_service.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool isOnline = true;
  bool simulateFailure = false;
  int queueCount = 0;
  String syncLog = 'No sync activity yet.';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final count = await SyncService.instance.getPendingCount();
    if (mounted) {
      setState(() {
        queueCount = count;
        isOnline = !AppConfig.isOfflineDemoMode;
      });
    }
  }

  Future<void> _toggleOnlineOffline() async {
    final newMode = !isOnline;
    await AppConfig.setOfflineDemoMode(!newMode);
    setState(() {
      isOnline = newMode;
    });
  }

  Future<void> _triggerSync() async {
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot sync while in offline mode.')),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await SyncService.instance.syncNow(
      simulateFailure: simulateFailure,
    );

    if (mounted) {
      setState(() {
        isLoading = false;
        queueCount = result.remainingPendingCount;
        syncLog = result.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JeevSarthi • Farmer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
            Text('Offline & sync', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Connection: ', style: TextStyle(fontSize: 15)),
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isOnline ? AppTheme.primaryGreen : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: _toggleOnlineOffline,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isOnline ? 'Go offline (demo)' : 'Go online (demo)',
                      style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (isOnline && !isLoading) ? _triggerSync : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOnline ? AppTheme.primaryGreen : Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      isLoading ? 'Syncing...' : 'Retry sync now',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Simulate failure on next sync', style: TextStyle(fontSize: 13)),
                    value: simulateFailure,
                    onChanged: (val) => setState(() => simulateFailure = val ?? false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Queue ($queueCount)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                queueCount == 0 ? 'Everything is synced.' : '$queueCount reports pending sync.',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Sync log', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(syncLog, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Data is stored on this device. The server is simulated in-browser for this demo; each record has a stable client ID so re-sending never creates duplicates.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
