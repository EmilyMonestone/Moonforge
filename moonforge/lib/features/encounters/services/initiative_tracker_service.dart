import 'package:moonforge/data/db/app_db.dart';

/// Service for managing initiative tracker state
class InitiativeTrackerService {
  InitiativeTrackerService._();
  /// Sort combatants by initiative (highest first), then by initiative modifier
  /// In case of tie, higher initiative modifier wins
  static List<Combatant> sortByInitiative(List<Combatant> combatants) {
    final sorted = [...combatants];
    sorted.sort((a, b) {
      // First compare by initiative
      final initiativeCompare = (b.initiative ?? 0).compareTo(
        a.initiative ?? 0,
      );
      if (initiativeCompare != 0) return initiativeCompare;
      // If tied, compare by initiative modifier
      final modifierCompare = b.initiativeModifier.compareTo(
        a.initiativeModifier,
      if (modifierCompare != 0) return modifierCompare;
      // If still tied, maintain original order
      return 0;
    });
    // Update order field based on sorted position
    for (var i = 0; i < sorted.length; i++) {
      sorted[i] = sorted[i].copyWith(order: i);
    }
    return sorted;
  }
  /// Roll initiative for a combatant (d20 + modifier)
  static int rollInitiative(int modifier) {
    // Note: In a real implementation, we'd use a random number generator
    // For now, we'll return modifier + 10 (average roll)
    // This should be replaced with: Random().nextInt(20) + 1 + modifier
    return modifier + 10;
  /// Get the next combatant in initiative order
  static int getNextCombatantIndex(
    List<Combatant> combatants,
    int currentIndex,
  ) {
    if (combatants.isEmpty) return 0;
    var nextIndex = currentIndex + 1;
    // Skip dead combatants
    while (nextIndex < combatants.length && !combatants[nextIndex].isAlive) {
      nextIndex++;
    // If we've reached the end, wrap to the beginning
    if (nextIndex >= combatants.length) {
      nextIndex = 0;
      // Find first alive combatant from the beginning
      while (nextIndex < combatants.length && !combatants[nextIndex].isAlive) {
        nextIndex++;
      }
    return nextIndex;
  /// Get the previous combatant in initiative order
  static int getPreviousCombatantIndex(
    var prevIndex = currentIndex - 1;
    // Skip dead combatants going backwards
    while (prevIndex >= 0 && !combatants[prevIndex].isAlive) {
      prevIndex--;
    // If we've reached the beginning, wrap to the end
    if (prevIndex < 0) {
      prevIndex = combatants.length - 1;
      // Find first alive combatant from the end
      while (prevIndex >= 0 && !combatants[prevIndex].isAlive) {
        prevIndex--;
    return prevIndex;
  /// Check if a new round should start (wrapped back to beginning)
  static bool isNewRound(int currentIndex, int nextIndex) {
    return nextIndex <= currentIndex;
  /// Get count of alive combatants
  static int getAliveCount(List<Combatant> combatants) {
    return combatants.where((c) => c.isAlive).length;
  /// Get count of alive allies
  static int getAliveAlliesCount(List<Combatant> combatants) {
    return combatants.where((c) => c.isAlive && c.isAlly).length;
  /// Get count of alive enemies
  static int getAliveEnemiesCount(List<Combatant> combatants) {
    return combatants.where((c) => c.isAlive && c.isEnemy).length;
  /// Check if encounter is over (all enemies or all allies are defeated)
  static bool isEncounterOver(List<Combatant> combatants) {
    final aliveAllies = getAliveAlliesCount(combatants);
    final aliveEnemies = getAliveEnemiesCount(combatants);
    return aliveAllies == 0 || aliveEnemies == 0;
  /// Get winner side if encounter is over
  static String? getWinner(List<Combatant> combatants) {
    if (!isEncounterOver(combatants)) return null;
    return aliveAllies > 0 ? 'allies' : 'enemies';
}
