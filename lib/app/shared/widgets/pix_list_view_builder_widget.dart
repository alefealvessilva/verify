import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:verify/app/core/admob_store.dart';
import 'package:verify/app/shared/services/pix_services/models/verify_pix_model.dart';
import 'package:verify/app/shared/widgets/pix_transaction_tile_widget.dart';
import 'package:verify/app/shared/widgets/transactions_not_found_widget.dart';

class PixListViewBuilder extends StatefulWidget {
  final List<VerifyPixModel> transactions;
  final bool isLoading;
  final bool useSliver;
  final String searchQuery;

  const PixListViewBuilder({
    super.key,
    required this.transactions,
    this.isLoading = false,
    this.useSliver = false,
    this.searchQuery = '',
  });

  @override
  State<PixListViewBuilder> createState() => _PixListViewBuilderState();
}

class _PixListViewBuilderState extends State<PixListViewBuilder> {
  final adMobStore = Modular.get<AdMobStore>();

  @override
  void initState() {
    super.initState();
    adMobStore.loadBannerAd();
  }

  @override
  void dispose() {
    adMobStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return widget.useSliver
          ? const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          : const Center(child: CircularProgressIndicator());
    }

    final filteredList = widget.transactions.where((pix) {
      if (widget.searchQuery.isEmpty) return true;
      final query = widget.searchQuery.toLowerCase();
      final name = pix.clientName.toLowerCase();
      return name.contains(query);
    }).toList();

    if (filteredList.isEmpty) {
      final emptyWidget = const Center(child: TransactionsNotFoundWidget());
      return widget.useSliver
          ? SliverFillRemaining(hasScrollBody: false, child: emptyWidget)
          : emptyWidget;
    }

    if (widget.useSliver) {
      return _buildSliverContent(context, filteredList);
    }
    return _buildBoxContent(context, filteredList);
  }

  Widget _buildBoxContent(BuildContext context, List<VerifyPixModel> list) {
    final groupedPix = _groupPixByDate(list);
    final groupKeys = groupedPix.keys.toList();

    return Column(
      children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: groupKeys.length,
          itemBuilder: (context, index) {
            final key = groupKeys[index];
            final items = groupedPix[key]!;
            return _buildGroup(context, key, items);
          },
        ),
        _buildBannerAd(),
      ],
    );
  }

  Widget _buildSliverContent(BuildContext context, List<VerifyPixModel> list) {
    final groupedPix = _groupPixByDate(list);
    final groupKeys = groupedPix.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == groupKeys.length) {
            return _buildBannerAd();
          }
          final key = groupKeys[index];
          final items = groupedPix[key]!;
          return _buildGroup(context, key, items);
        },
        childCount: groupKeys.length + 1,
      ),
    );
  }

  Map<String, List<VerifyPixModel>> _groupPixByDate(List<VerifyPixModel> listPix) {
    final Map<String, List<VerifyPixModel>> groupedPix = {};
    for (var pix in listPix) {
      final date = pix.date;
      final now = DateTime.now();
      String dayGroup;

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        dayGroup = 'Hoje';
      } else if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day - 1) {
        dayGroup = 'Ontem';
      } else {
        dayGroup = DateFormat('dd \'de\' MMMM', 'pt_BR').format(date);
      }

      if (!groupedPix.containsKey(dayGroup)) {
        groupedPix[dayGroup] = [];
      }
      groupedPix[dayGroup]!.add(pix);
    }
    return groupedPix;
  }

  Widget _buildGroup(BuildContext context, String key, List<VerifyPixModel> items) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              key,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items.map((pix) => PixTransactionTileWidget(
                clientName: pix.clientName,
                value: pix.value,
                date: pix.date,
              )),
        ],
      ),
    );
  }

  Widget _buildBannerAd() {
    return Observer(
      builder: (context) {
        return Visibility(
          visible: adMobStore.bannerAd != null,
          child: Container(
            width: adMobStore.bannerAd?.size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
            child: adMobStore.hasBannerAd
                ? AdWidget(ad: adMobStore.bannerAd!)
                : null,
          ),
        );
      },
    );
  }
}
