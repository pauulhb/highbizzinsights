import 'package:flutter/material.dart';

import '../repositories/manager_repository.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final root = ManagerRepository().organizationTree();
    return Scaffold(
      appBar: AppBar(title: const Text('Manager view')),
      body: _HierarchyLevel(node: root, breadcrumb: const []),
    );
  }
}

class _HierarchyLevel extends StatelessWidget {
  const _HierarchyLevel({required this.node, required this.breadcrumb});
  final HierarchyNode node;
  final List<String> breadcrumb;

  @override
  Widget build(BuildContext context) {
    final trail = [...breadcrumb, node.name];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            trail.join(' › '),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: ListView(
            children: node.children
                .map((child) => ListTile(
                      leading: Icon(child.isLeaf
                          ? Icons.person_outline
                          : Icons.account_tree_outlined),
                      title: Text(child.name),
                      trailing: child.isLeaf ? null : const Icon(Icons.chevron_right),
                      onTap: child.isLeaf
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => Scaffold(
                                    appBar: AppBar(title: Text(child.name)),
                                    body: _HierarchyLevel(node: child, breadcrumb: trail),
                                  ),
                                ),
                              ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
