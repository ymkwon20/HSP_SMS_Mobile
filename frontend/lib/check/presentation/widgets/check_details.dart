import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/check/presentation/remark_popup.dart';
import 'package:frontend/check/presentation/widgets.dart';
import 'package:frontend/check/shared/providers.dart';
import 'package:frontend/core/presentation/constants/constants.dart';
import 'package:frontend/core/presentation/routes/hero_dialog_router.dart';
import 'package:frontend/core/presentation/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckListDetailsSection extends ConsumerWidget {
  const CheckListDetailsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(checkInfoStateNotifierProvider
        .select((state) => state.info.details.length));

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return CheckDetailsCard(
          index: index,
        );
      },
    );
  }
}

const resultOptions = ["양호", "불량"];

class CheckDetailsCard extends ConsumerWidget {
  const CheckDetailsCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  // Todo: change these fields to one entity
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(checkInfoStateNotifierProvider
        .select((state) => state.info.details[index]));

    return Hero(
      tag: detail.chkItemCd,
      createRectTween: (begin, end) => CustomRectTween(begin: begin, end: end),
      child: SizedBox(
        height: 190,
        child: Padding(
          padding: const EdgeInsets.all(LayoutConstants.paddingS),
          child: Material(
            color: Theme.of(context).bottomAppBarColor,
            elevation: 2,
            borderRadius: BorderRadius.circular(LayoutConstants.radiusS),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LayoutConstants.paddingL,
                vertical: LayoutConstants.paddingM,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(width: LayoutConstants.spaceL),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  bottom: LayoutConstants.paddingM),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // TODO: Image picking
                                      ref
                                          .read(checkInfoStateNotifierProvider
                                              .notifier)
                                          .pickImages(index);
                                    },
                                    child: Stack(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                LayoutConstants.paddingS,
                                          ),
                                          child: Icon(
                                            Icons.add_a_photo,
                                          ),
                                        ),
                                        // TODO: add logic for showing image counts if images are taken
                                        if (detail.images.isEmpty)
                                          const SizedBox()
                                        else
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        LayoutConstants
                                                            .radiusM),
                                              ),
                                              padding: const EdgeInsets
                                                      .symmetric(
                                                  horizontal: (LayoutConstants
                                                              .paddingXS +
                                                          LayoutConstants
                                                              .paddingS) /
                                                      2),
                                              child: Text(
                                                detail.images.length.toString(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                      fontSize: 11,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          // TODO: Cached Image Clear
                                          ref
                                              .read(
                                                  checkInfoStateNotifierProvider
                                                      .notifier)
                                              .clearDetailsImages(index);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                LayoutConstants.paddingS,
                                          ),
                                          child: Icon(
                                            Icons.refresh,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: LayoutConstants.paddingM),
                              child: Text(
                                detail.chkItemNm,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: LayoutConstants.spaceM),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  HeroDialogRouter(
                                    builder: (context) => Center(
                                      child: RemarkPopupCard(
                                        index: index,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30,
                                margin: const EdgeInsets.only(
                                  left: LayoutConstants.marginM,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      LayoutConstants.radiusM),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: LayoutConstants.paddingM),
                                child: Text(detail.remark,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                        )),
                              ),
                            ),
                            const SizedBox(height: LayoutConstants.spaceM),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("${detail.methodChk} 확인 결과:"),
                                const SizedBox(width: LayoutConstants.spaceL),
                                CheckToggle(
                                  isSelected: List<bool>.generate(
                                      resultOptions.length,
                                      (optionsIdx) =>
                                          resultOptions[optionsIdx] ==
                                          detail.result),
                                  children: resultOptions,
                                  onPressed: (clickedIdx) {
                                    ref
                                        .read(checkInfoStateNotifierProvider
                                            .notifier)
                                        .setCheckResult(
                                            index, resultOptions[clickedIdx]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}