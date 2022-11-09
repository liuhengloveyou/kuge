import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/bottomPlayerBar.dart';
import 'package:kuge_app/pages/search/model_search_history.dart';
import 'package:kuge_app/pages/search/search_suggestion.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/utils/view.dart';
import 'package:provider/provider.dart';
import 'search_result_page.dart';

class SearchPageRoute<T> extends PageRoute<T> {
  SearchPageRoute(this._proxyAnimation)
      : super(settings: const RouteSettings(name: Routes.pageSearch));
  final ProxyAnimation _proxyAnimation;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    _proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SearchPage(
      animation: animation,
    );
  }
}

class SearchPage extends StatefulWidget {
  final Animation<double> animation;
  const SearchPage({Key? key, required this.animation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String get query => _queryTextController.text;

  set query(String value) {
    _queryTextController.text = value;
  }

  ///the query of [_SearchResultPage]
  String _searchedQuery = "";

  bool initialState = true;

  @override
  void initState() {
    super.initState();
    _queryTextController.addListener(_onQueryTextChanged);
    widget.animation.addStatusListener(_onAnimationStatusChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _queryTextController.removeListener(_onQueryTextChanged);
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    PreferredSizeWidget? tabs;
    if (!initialState) {
      tabs = TabBar(
          indicator:
              const UnderlineTabIndicator(insets: EdgeInsets.only(bottom: 4)),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: SECTIONS.map((title) => Tab(child: Text(title))).toList());
    }

    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: SECTIONS.length,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: theme.primaryIconTheme,
              brightness: theme.primaryColorBrightness,
              leading: const BackButton(),
              title: TextField(
                controller: _queryTextController,
                focusNode: _focusNode,
                style: theme.primaryTextTheme.headline6,
                textInputAction: TextInputAction.search,
                onSubmitted: (String _) => _search(query),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: theme.primaryTextTheme.headline6,
                    hintText:
                        MaterialLocalizations.of(context).searchFieldLabel),
              ),
              actions: buildActions(context),
              bottom: tabs,
              toolbarTextStyle: theme.primaryTextTheme.bodyText2,
              titleTextStyle: theme.primaryTextTheme.headline6,
            ),
            resizeToAvoidBottomInset: false,
            body: initialState
                ? _EmptyQuerySuggestionSection(
                    suggestionSelectedCallback: (query) => _search(query))
                : SearchResultPage(query: _searchedQuery),
            bottomSheet: BottomControllerBar(),
          ),
        ),
        SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: buildSuggestions(context)))
      ],
    );
  }

  ///start search for keyword
  void _search(String query) {
    if (query.isEmpty) {
      return;
    }
    context.read<SearchHistory>().insertSearchHistory(query);
    _focusNode.unfocus();
    setState(() {
      initialState = false;
      _searchedQuery = query;
      this.query = query;
    });
  }

  void _onQueryTextChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    //we need request focus on text field when first in
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onFocusChanged() {
    setState(() {});
  }

  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: '清除',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty ||
        !isSoftKeyboardDisplay(MediaQuery.of(context)) ||
        !_focusNode.hasFocus) {
      return const SizedBox(height: 0, width: 0);
    }
    return const SizedBox(height: 0, width: 0); // 没有搜索建议
    // return SuggestionOverflow(
    //   query: query,
    //   onSuggestionSelected: (keyword) {
    //     query = keyword;
    //     _search(query);
    //   },
    // );
  }
}

///when query is empty, show default suggestions
///with hot query keyword from network
///with query history from local
class _EmptyQuerySuggestionSection extends StatelessWidget {
  const _EmptyQuerySuggestionSection(
      {Key? key, required this.suggestionSelectedCallback})
      : super(key: key);

  final SuggestionSelectedCallback suggestionSelectedCallback;

  @override
  Widget build(BuildContext context) {
    SearchHistory searchHistory = context.watch<SearchHistory>();

    return ListView(
      children: <Widget>[
        // Loader<List<String>>(
        //     // loadTask: () => neteaseRepository.searchHotWords(),
        //     //hide when failed load hot words
        //     errorBuilder: (context, result) => Container(),
        //     loadingBuilder: (context) {
        //       return SuggestionSection(
        //         title: "热门搜索",
        //         content: Loader.buildSimpleLoadingWidget(context),
        //       );
        //     },
        //     builder: (context, result) {
        //       return SuggestionSection(
        //         title: "热门搜索",
        //         content: SuggestionSectionContent.from(
        //           words: result,
        //           suggestionSelectedCallback: suggestionSelectedCallback,
        //         ),
        //       );
        //     }),
        SuggestionSection(
            title: '搜索记录',
            content: SuggestionSectionContent.from(
              words: searchHistory.histories,
              suggestionSelectedCallback: suggestionSelectedCallback,
            ),
            onDeleteClicked: () => searchHistory.clearSearchHistory())
      ],
    );
  }
}
