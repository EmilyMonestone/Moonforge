# Domain Visuals System - Documentation Index

Welcome to the Domain Visuals System documentation! This system provides a centralized, type-safe way to manage icons and colors for domain types across the Moonforge Flutter application.

## 🚀 Getting Started

**New to the system?** Start here:

1. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** ⭐
   - One-page cheat sheet with all common patterns
   - Quick lookup table of all domain types and icons
   - Copy-paste code examples
   - **Best for:** Quick lookups and daily use

2. **[README.md](README.md)**
   - Complete usage guide with detailed examples
   - How to access icons, colors, and configs
   - Integration patterns for common UI components
   - **Best for:** Learning the system thoroughly

## 📚 Complete Documentation

### Core Documentation

- **[README.md](README.md)** - Main usage guide (188 lines)
  - Getting started
  - All access patterns
  - Integration examples
  - Adding new domain types
  
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Cheat sheet (200 lines)
  - Quick access patterns
  - All domain types table
  - Common UI patterns
  - Migration examples

### Implementation Details

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture (245 lines)
  - Component diagrams
  - Data flow diagrams
  - File dependencies
  - Type hierarchy
  - Access patterns comparison

- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Complete summary (240 lines)
  - What was implemented
  - Key features
  - Available domain types
  - File structure
  - Next steps
  - Testing instructions

### Migration & Adoption

- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Migration instructions (299 lines)
  - Step-by-step migration
  - Before/after examples
  - Common patterns
  - File priorities
  - Benefits of migration
  - Backward compatibility info

## 📁 Source Files

- **[domain_visuals.dart](domain_visuals.dart)** - Main implementation (210 lines)
  - `DomainVisualConfig` class
  - `DomainVisuals` registry
  - `DomainTypeVisuals` extension
  - Entity kind conversion methods

- **[../models/domain_type.dart](../models/domain_type.dart)** - Enum definition (62 lines)
  - All 18 domain type enum values
  - Comprehensive documentation

## 🧪 Tests & Examples

- **[../../test/core/design/domain_visuals_test.dart](../../../test/core/design/domain_visuals_test.dart)** - Tests (213 lines)
  - Unit tests for all domain types
  - Entity kind conversion tests
  - Extension method tests
  - Widget tests

- **[../widgets/domain_visuals_example.dart](../widgets/domain_visuals_example.dart)** - Example widget (270 lines)
  - Comprehensive usage examples
  - All access patterns demonstrated
  - Common UI patterns shown
  - Can be run as a demo screen

## 🗺️ Navigation Guide

### By Use Case

**"I want to use icons in my widget"**
→ Start with [QUICK_REFERENCE.md](QUICK_REFERENCE.md) section "Quick Access Patterns"

**"I'm migrating existing code"**
→ Read [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) section "Step-by-Step Migration"

**"I need to understand how it works"**
→ Check [ARCHITECTURE.md](ARCHITECTURE.md) for diagrams and flow

**"I want to add a new domain type"**
→ See [README.md](README.md) section "Adding New Domain Types"

**"I need examples of different UI patterns"**
→ Look at [domain_visuals_example.dart](../widgets/domain_visuals_example.dart)

**"I want to know what was implemented"**
→ Read [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

### By Experience Level

**Beginner:**
1. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Get the basics
2. [domain_visuals_example.dart](../widgets/domain_visuals_example.dart) - See it in action
3. [README.md](README.md) - Learn more details

**Intermediate:**
1. [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Migrate existing code
2. [README.md](README.md) - Learn all features
3. [ARCHITECTURE.md](ARCHITECTURE.md) - Understand the design

**Advanced:**
1. [ARCHITECTURE.md](ARCHITECTURE.md) - Deep dive into design
2. [domain_visuals.dart](domain_visuals.dart) - Study implementation
3. [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Full picture

## 📊 Documentation Statistics

| Document | Lines | Purpose |
|----------|-------|---------|
| QUICK_REFERENCE.md | 200 | Daily reference |
| README.md | 188 | Main guide |
| MIGRATION_GUIDE.md | 299 | Migration help |
| ARCHITECTURE.md | 245 | System design |
| IMPLEMENTATION_SUMMARY.md | 240 | Overview |
| domain_visuals.dart | 210 | Implementation |
| domain_type.dart | 62 | Type definitions |
| domain_visuals_example.dart | 270 | Examples |
| domain_visuals_test.dart | 213 | Tests |
| **Total** | **1,927** | **Complete system** |

## 🎯 Key Concepts

### Domain Types
18 enum values representing all major entities in the app:
- Campaign structure (4 types)
- Gameplay (5 types)
- Content (1 type)
- Entity kinds (8 types)

### Visual Configuration
Each domain type has:
- Required: IconData icon
- Optional: Color color
- Optional: String semanticLabel

### Access Patterns
Multiple ways to access the same information:
- Extension methods: `DomainType.campaign.icon`
- Static methods: `DomainVisuals.getIcon(DomainType.campaign)`
- Helper methods: `EntityFormatters.getKindIcon(kind)`

## 🔗 External Links

- Tests: `test/core/design/domain_visuals_test.dart`
- Example Widget: `lib/core/widgets/domain_visuals_example.dart`
- Sample Integrations:
  - `lib/features/campaign/widgets/campaign_card.dart`
  - `lib/features/chapter/widgets/chapter_card.dart`
  - `lib/features/chapter/widgets/chapter_stats_widget.dart`
  - `lib/features/entities/utils/entity_formatters.dart`

## 💡 Quick Tips

1. **Use the extension methods** - Most convenient: `DomainType.campaign.icon`
2. **Check QUICK_REFERENCE.md first** - Fastest way to find what you need
3. **Entity kinds are supported** - Use `getEntityKindIcon(kind)` for entities
4. **Migration is optional** - Gradual adoption is fine
5. **Tests are comprehensive** - Run them to verify everything works
6. **All values are const** - Zero runtime performance impact

## 📞 Support

If you need help:
1. Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for quick answers
2. Read [README.md](README.md) for detailed examples
3. Review [domain_visuals_example.dart](../widgets/domain_visuals_example.dart) for code examples
4. Look at existing integrations in `lib/features/` for real usage

## 🎉 Summary

This documentation covers a complete, production-ready system for centralized domain visuals. The system is:
- ✅ Type-safe and compile-time checked
- ✅ Zero runtime overhead
- ✅ Fully documented with 1,927 lines
- ✅ Comprehensively tested
- ✅ Easy to use and extend
- ✅ Ready for team adoption

**Happy coding!** 🚀

---
**Version:** 1.0  
**Last Updated:** 2025-11-12  
**Maintainer:** Moonforge Team
