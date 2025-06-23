// features/inventory/presentation/pages/inventory_screen.dart

import 'package:flutter/material.dart';
import '/features/volunteer/presentation/widgets/warehouse_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/colors.dart';
import '../providers/inventory_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/shelf_card.dart';
import '../widgets/donation_card.dart';
import 'article_detail_screen.dart';
import 'shelf_detail_screen.dart';
import 'warehouse_detail_screen.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(inventoryNotifierProvider.notifier).loadInitialData(),
    );
    _tabController = TabController(length: 3, vsync: this);
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _navigateToWarehouseDetail(int warehouseId, String warehouseName) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WarehouseDetailScreen(
              warehouseId: warehouseId,
              warehouseName: warehouseName,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToShelfDetail(int shelfId) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ShelfDetailScreen(shelfId: shelfId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToArticleDetail(int articleId) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ArticleDetailScreen(articleId: articleId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en los mensajes de error/éxito
    ref.listen(
      inventoryNotifierProvider.select((state) => state.errorMessage),
      (previous, next) {
        if (next != null) {
          _showSnackBar(next, AppColors.errorColor, Icons.error_outline);
          // Limpiar el mensaje después de mostrarlo
          ref.read(inventoryNotifierProvider.notifier).clearMessages();
        }
      },
    );

    ref.listen(
      inventoryNotifierProvider.select((state) => state.successMessage),
      (previous, next) {
        if (next != null) {
          _showSnackBar(
            next,
            AppColors.successColor,
            Icons.check_circle_outline,
          );
          // Limpiar el mensaje después de mostrarlo
          ref.read(inventoryNotifierProvider.notifier).clearMessages();
        }
      },
    );

    final isLoading = ref.watch(isLoadingInventoryProvider);

    if (isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [_buildSliverAppBar()];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildWarehousesView(),
            _buildShelvesView(),
            _buildDonationsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cream, AppColors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Cargando inventario...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.accentBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            Consumer(
              builder: (context, ref, _) {
                final errorMessage = ref.watch(
                  inventoryNotifierProvider.select(
                    (state) => state.errorMessage,
                  ),
                );
                if (errorMessage != null) {
                  return Text(
                    errorMessage,
                    style: TextStyle(color: AppColors.errorColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final isDownloading = ref.watch(isDownloadingProvider);

    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 107, left: 30),
        title: const Text(
          'Inventario',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDownloading
                  ? null
                  : () {
                      ref
                          .read(inventoryNotifierProvider.notifier)
                          .downloadExcelReportAction();
                    },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accent,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.download_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        child: Column(
          children: [
            Container(height: 1, color: Colors.white.withOpacity(0.3)),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white.withOpacity(0.7),
              tabs: const [
                Tab(icon: Icon(Icons.warehouse), text: 'Almacenes'),
                Tab(icon: Icon(Icons.shelves), text: 'Estantes'),
                Tab(icon: Icon(Icons.inventory), text: 'Donaciones'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehousesView() {
    final warehouses = ref.watch(warehousesProvider);

    if (warehouses.isEmpty) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: const EmptyStateWidget(
          icon: Icons.inventory_2_rounded,
          title: 'No hay almacenes disponibles',
          subtitle: 'Los almacenes aparecerán aquí cuando estén configurados',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(inventoryNotifierProvider.notifier).refreshInventory();
      },
      color: AppColors.accent,
      backgroundColor: AppColors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: warehouses.length,
        itemBuilder: (context, index) {
          final warehouse = warehouses[index];
          return FadeTransition(
            opacity: _fadeAnimation,
            child: WarehouseCard(
              warehouse: warehouse,
              onTap: () =>
                  _navigateToWarehouseDetail(warehouse.id, warehouse.name),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShelvesView() {
    final shelves = ref.watch(shelvesProvider);

    if (shelves.isEmpty) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: const EmptyStateWidget(
          icon: Icons.inventory_2_rounded,
          title: 'No hay estantes disponibles',
          subtitle: 'Los estantes aparecerán aquí cuando estén configurados',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(inventoryNotifierProvider.notifier).refreshInventory();
      },
      color: AppColors.accent,
      backgroundColor: AppColors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: shelves.length,
        itemBuilder: (context, index) {
          final shelf = shelves[index];
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ShelfCard(
              shelf: shelf,
              onTap: () => _navigateToShelfDetail(shelf.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDonationsView() {
    final donations = ref.watch(donationsProvider);
    print('Cantidad de donaciones: ${donations.length}');

    if (donations.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_rounded,
        title: 'No hay donaciones registradas',
        subtitle: 'Las donaciones aparecerán aquí cuando se registren',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(inventoryNotifierProvider.notifier).loadDonations();
      },
      color: AppColors.accent,
      backgroundColor: AppColors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return DonationCard(
            donation: donation,
            index: index,
            onStatusUpdate: (newStatus) {
              ref
                  .read(inventoryNotifierProvider.notifier)
                  .updateDonationStatusAction(donation.id, newStatus, index);
            },
            onTap: () => _navigateToArticleDetail(donation.id),
          );
        },
      ),
    );
  }
}
