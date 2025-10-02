import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:garage_management/src/model/service.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/provider/brandProvider.dart';
import 'package:garage_management/src/provider/partProvider.dart';
import 'package:garage_management/src/screen/BookingScreen.dart';
import 'package:garage_management/src/screen/ModelsScreen.dart';
import 'package:garage_management/src/theme/app_theme.dart';

final servicesProvider = StreamProvider<List<Service>>((ref) {
  return FirebaseFirestore.instance
      .collection('services')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Service.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});

final suppliersProvider = StreamProvider<List<SupplierItem>>((ref) {
  return FirebaseFirestore.instance
      .collection('suppliers')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => SupplierItem.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});

final suppliersItemsProvider = StreamProvider<List<SupplierItem>>((ref) {
  return FirebaseFirestore.instance
      .collection('suppliersItems')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => SupplierItem.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});

class Accuile extends ConsumerStatefulWidget {
  const Accuile({super.key});

  @override
  ConsumerState<Accuile> createState() => _AccuileState();
}

class _AccuileState extends ConsumerState<Accuile> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isCollapsed) {
      setState(() => _isCollapsed = true);
    } else if (_scrollController.offset <= 100 && _isCollapsed) {
      setState(() => _isCollapsed = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);
    final suppliersAsync = ref.watch(suppliersProvider);
    final partsAsync = ref.watch(AllpartsProvider);
    final modelsAsync = ref.watch(AllmodelsProvider);
    final categoryAsync = ref.watch(brandsProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Professional Hero Header with SliverAppBar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: false,
            backgroundColor: AppColors.primaryGold,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedOpacity(
                opacity: _isCollapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'ALN Motorbike',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "30 Years",
                      style: TextStyle(
                        color: const Color.fromARGB(221, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: "", // no url, will fallback
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        Image.asset("assets/ALn.png", fit: BoxFit.fill),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/ALn.png", fit: BoxFit.fill),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ALN Motorbike",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "30 Years",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Expert Maintenance",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 245, 212, 3),
                    const Color.fromARGB(255, 164, 116, 3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Services", servicesAsync.value?.length ?? 0),
                  _buildDivider(),
                  _buildStatItem("Parts", partsAsync.value?.length ?? 0),
                  _buildDivider(),
                  _buildStatItem("Suppliers", categoryAsync.value?.length ?? 0),
                ],
              ),
            ),
          ),
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: false,
            //stretch: true,
            //  backgroundColor: const Color.fromARGB(255, 59, 186, 232),
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedOpacity(
                opacity: _isCollapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Popular Service',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                    Text(
                      '${servicesAsync.value?.length ?? 0}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              background:
                  // Services Section
                  servicesAsync.when(
                    data: (services) {
                      if (services.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          _buildSectionHeader("Popular Services", Icons.build),
                          Expanded(
                            child: SizedBox(
                              height: 260,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  final service = services[index];
                                  return _buildServiceCard(context, service);
                                },
                              ),
                            ),
                          ),
                         // const SizedBox(height: 24),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Error loading services: $e"),
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(child: Divider(height: 40)),
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: false,
            backgroundColor: const Color.fromARGB(163, 249, 253, 255),
            flexibleSpace: FlexibleSpaceBar(
              // title: AnimatedOpacity(
              //   opacity: _isCollapsed ? 1.0 : 0.0,
              //   duration: const Duration(milliseconds: 200),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       const Text(
              //         'Popular categorys',
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: Color.fromARGB(255, 39, 4, 4),
              //         ),
              //       ),
              //       Text(
              //         '${categoryAsync.value?.length ?? 0}',
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              background:
                  // Services Section
                  categoryAsync.when(
                    data: (categorys) {
                      if (categorys.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          Expanded(flex: 1,
                            child: _buildSectionHeader(
                              "Popular categorys",
                              Icons.settings,
                            ),
                          ),

                          // Enhanced horizontal scrolling category list
                          Expanded(flex: 3,
                            child: SizedBox(
                            //  height: 300,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: categorys.length,
                                itemBuilder: (context, index) {
                                  final part = categorys[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index == categorys.length - 1
                                          ? 0
                                          : 10,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ModelsScreen(
                                              brandId: part.id,
                                              brandName: part.name,
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: _buildCategoryCard(part, index),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          //  const SizedBox(height: 24),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Error loading parts: $e"),
                    ),
                  ),
            ),
          ),

          // Models & Parts Section
          modelsAsync.when(
            data: (models) {
              if (models.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }

              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Available Models", Icons.motorcycle),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: models.length,
                        itemBuilder: (context, index) {
                          final model = models[index];
                          final partsAsync = ref.watch(partsProvider(model.id));

                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: CachedNetworkImage(
                                            imageUrl: model.logo ?? "",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                                      Icons.motorcycle,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                          ),
                                        ),

                                        // Icon(
                                        //                                           Icons.motorcycle,
                                        //                                           color: Colors.blue.shade700,
                                        //                                           size: 24,
                                        //                                         ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Year ${model.year}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: partsAsync.when(
                                      data: (parts) {
                                        if (parts.isEmpty) {
                                          return Center(
                                            child: Text(
                                              "No parts available",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          );
                                        }
                                        return Text(
                                          "${parts.length} parts available",
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                      loading: () => const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      error: (e, _) => Text(
                                        "Error loading parts",
                                        style: TextStyle(
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (e, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // Services Section
          servicesAsync.when(
            data: (services) {
              if (services.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildSectionHeader("Popular Services", Icons.build),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return _buildServiceCard(context, service);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error loading services: $e"),
              ),
            ),
          ),

          // Parts Section
          // Parts Section
          partsAsync.when(
            data: (parts) {
              if (parts.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildSectionHeader("Popular Parts", Icons.settings),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: parts.length,
                        itemBuilder: (context, index) {
                          final part = parts[index];
                          return InkWell(
                            onTap: () {
                              // Navigate to the booking screen for this part
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingScreen(
                                    itemId: part.id,
                                    itemName: part.name,
                                    itemDescription:
                                        "Stock: ${part.stock}, Original: ${part.isOriginal}",
                                    itemPrice: part.price,
                                    itemImage:
                                        "", // if you have an image URL for the part
                                    itemType:
                                        "part", // indicate that this booking is for a part
                                  ),
                                ),
                              );
                            },
                            child: _buildPartCard(part),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error loading parts: $e"),
              ),
            ),
          ),

          // Suppliers Section
          suppliersAsync.when(
            data: (suppliers) {
              if (suppliers.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildSectionHeader("Trusted Suppliers", Icons.store),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: suppliers.length,
                        itemBuilder: (context, index) {
                          final supplier = suppliers[index];
                          return _buildSupplierCard(supplier);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error loading suppliers: $e"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.white30);
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                itemId: service.id,
                itemName: service.name,
                itemDescription: service.description,
                itemPrice: service.price.toDouble(),
                itemImage: service.imageUrl,
                itemType: "service", // <--- important
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: service.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
            Expanded(flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3,left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.description,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${service.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //   Widget _buildCateegoryCard(part) {
  //     return Container(
  //       width: 160,
  // padding: EdgeInsets.all(8),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           ClipRRect(
  //             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
  //             child: part.logo != null && part.logo!.isNotEmpty
  //                 ? CachedNetworkImage(
  //                     imageUrl: part.logo,
  //                     height: 100,
  //                     width: double.infinity,
  //                     fit: BoxFit.cover,
  //                     placeholder: (context, url) => Container(
  //                       color: Colors.grey[200],
  //                       child: const Center(child: CircularProgressIndicator()),
  //                     ),
  //                     errorWidget: (context, url, error) => Container(
  //                       color: Colors.grey[200],
  //                       child: const Icon(
  //                         Icons.build,
  //                         size: 40,
  //                         color: Colors.grey,
  //                       ),
  //                     ),
  //                   )
  //                 : Container(
  //                     height: 100,
  //                     color: Colors.grey[200],
  //                     child: const Center(
  //                       child: Icon(Icons.build, size: 40, color: Colors.grey),
  //                     ),
  //                   ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   part.name,
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 14,
  //                   ),
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  Widget _buildPartCard(part) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: part.imageUrl != null && part.imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: part.imageUrl!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.build,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.build, size: 40, color: Colors.grey),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${part.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Stock: ${part.stock}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierCard(SupplierItem supplier) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CachedNetworkImage(
          imageUrl: supplier.logoUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.store, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(part, int index) {
    // Generate gradient colors based on index for variety
    final gradientColors = _getGradientColors(index);

    return Hero(
      tag: 'category_${part.id}',
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section with gradient overlay
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    part.logo != null && part.logo!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: part.logo,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    gradientColors[0].withOpacity(0.3),
                                    gradientColors[1].withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      gradientColors[0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: gradientColors,
                                ),
                              ),
                              child: Icon(
                                Icons.directions_bike_rounded,
                                size: 20,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: gradientColors,
                              ),
                            ),
                            child: Icon(
                              Icons.directions_bike_rounded,
                              size: 48,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),

                    // Gradient overlay for better text contrast
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Shine effect overlay
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content section
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(left:3,right: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: gradientColors[0].withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                   // crossAxisAlignment: CrossAxisAlignment.start,

                    
                    children: [
                      // Category name
                      Text(
                        part.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.2,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Action button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              color: gradientColors[0],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                          //  padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradientColors),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors[0].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to generate gradient colors based on index
  List<Color> _getGradientColors(int index) {
    final gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)], // Purple-Blue
      [const Color(0xFFf093fb), const Color(0xFff5576c)], // Pink-Red
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)], // Light Blue
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)], // Green-Cyan
      [const Color(0xFFfa709a), const Color(0xFFfee140)], // Pink-Yellow
      [const Color(0xFF30cfd0), const Color(0xFF330867)], // Cyan-Purple
      [const Color(0xFFa8edea), const Color(0xFFfed6e3)], // Mint-Pink
      [const Color(0xFFff9a9e), const Color(0xFFfecfef)], // Coral-Pink
    ];

    return gradients[index % gradients.length];
  }
}
