/// Static demo hierarchy for the manager drill-down screen: Region -> State
/// -> HQ -> KAM -> Customer -> Visit. A production build would replace this
/// with a repository backed by /manager/hierarchy on the server; on-device
/// visit counts for the signed-in KAM still come from the local database
/// via ReportService, this only supplies the org tree shape.
class HierarchyNode {
  HierarchyNode(this.name, this.children);
  final String name;
  final List<HierarchyNode> children;
  bool get isLeaf => children.isEmpty;
}

class ManagerRepository {
  HierarchyNode organizationTree() {
    return HierarchyNode('South Region', [
      HierarchyNode('Karnataka', [
        HierarchyNode('Bengaluru HQ', [
          HierarchyNode('Ravi Kumar (KAM)', []),
          HierarchyNode('Deepa Menon (KAM)', []),
        ]),
        HierarchyNode('Mysuru HQ', [
          HierarchyNode('Arjun Das (KAM)', []),
        ]),
      ]),
      HierarchyNode('Tamil Nadu', [
        HierarchyNode('Chennai HQ', [
          HierarchyNode('Kavya Pillai (KAM)', []),
          HierarchyNode('Suresh Babu (KAM)', []),
        ]),
      ]),
      HierarchyNode('Telangana', [
        HierarchyNode('Hyderabad HQ', [
          HierarchyNode('Farhan Ali (KAM)', []),
        ]),
      ]),
    ]);
  }
}
