import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:color_picker/color_picker.dart';

// Just a simple way to leave a trace of what version you built a Flutter
// Web demo with inside the app. You can also show it in the demo,
// like in this example, so people testing it don't have to ask.
const String kFlutterVersion = 'master 1.24.0-4.0.pre.138';

// Max width of the body content when used on a wide screen.
const double kMaxBodyWidth = 700;

// More extensive demo of the ColorPicker, also published as a live web demo
// here: https://rydmike.com/democolorpicker
void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make status bar transparent in Android, results in an iPhone like look
    // when used in combination with the AppBar theme below.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ColorPicker Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        // This AppBarTheme setup is part of emulating the light iPhone
        // appbar look on both Android and iOS, when using Material AppBar
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          // Using a barely transparent white appbar, it is not a frosted
          // glass effect, but much cheaper to render than such a filter effect.
          color: Colors.white.withOpacity(0.9),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        // Make a prettier button theme that is based on same color as
        // the primary color, otherwise buttons are grey.
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // This spacing adds back the top safe area that we loose with
          // extendBodyBehindAppBar = true
          SizedBox(height: MediaQuery.of(context).padding.top),
          const Spacer(),
          Text(
            'COLOR PICKER',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 8,
                elevation: 4,
                color: Colors.blueAccent[200],
                isSelected: true,
              ),
              const SizedBox(width: 16),
              ColorIndicator(
                height: 60,
                width: 60,
                color: Colors.blue[100],
                hasBorder: true,
              ),
              const SizedBox(width: 16),
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 30,
                elevation: 8,
                color: Colors.indigo[600],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 30,
                elevation: 9,
                color: Colors.red[800],
              ),
              const SizedBox(width: 16),
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 0,
                color: Colors.redAccent[100],
                hasBorder: true,
              ),
              const SizedBox(width: 16),
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 16,
                elevation: 5,
                color: Colors.pink[800],
                isSelected: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 4,
                elevation: 1,
                color: Colors.amber[400],
              ),
              const SizedBox(width: 16),
              ColorIndicator(
                height: 60,
                width: 60,
                borderRadius: 30,
                elevation: 1,
                color: Colors.orange[300],
                isSelected: true,
              ),
              const SizedBox(width: 16),
              ColorIndicator(
                height: 60,
                width: 60,
                color: Colors.amber[800],
              ),
            ],
          ),
          const SizedBox(height: 40),
          OutlineButton(
            onPressed: () {
              Navigator.push<Object>(
                context,
                MaterialPageRoute<Object>(
                    builder: (BuildContext context) => const ColorPickerPage()),
              );
            },
            child: const Text('Try the color picker '),
          ),
          const Spacer(),
          Text(
            'Built with Flutter $kFlutterVersion',
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key key}) : super(key: key);

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  bool selectShadeColors = true;
  bool showColorName = true;
  bool useBorder = false;
  bool useBorderWheel = false;
  bool centerContent = true;
  bool showHeading = true;
  bool showSubHeading = true;
  bool includeIndex850 = false;

  final double sizeMin = 20;
  final double sizeMax = 60;
  double size = 40;

  double elevation = 0;
  double borderRadius = 4;

  double spacing = 4;
  double runSpacing = 4;
  double padding = 10;
  double wheelSize = 190;
  double wheelWidth = 16;

  Color screenPickerColor;
  Color dialogPickerColor;

  static final Map<ColorPickerSwatch, bool> swatchAvailable =
      <ColorPickerSwatch, bool>{
    ColorPickerSwatch.both: false,
    ColorPickerSwatch.material: true,
    ColorPickerSwatch.accent: true,
    ColorPickerSwatch.bw: false,
    ColorPickerSwatch.custom: true,
    ColorPickerSwatch.any: true,
  };

  static const double kTogglePadding = 7;
  static const double kToggleFontSize = 10;

  final List<Widget> toggleButtons = <Widget>[
    const Padding(
      padding: EdgeInsets.fromLTRB(kTogglePadding, 0, kTogglePadding, 0),
      child: Text('Primary &\nAccent',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: kToggleFontSize)),
    ),
    const Padding(
      padding: EdgeInsets.fromLTRB(kTogglePadding, 0, kTogglePadding, 0),
      child: Text('Primary', style: TextStyle(fontSize: kToggleFontSize)),
    ),
    const Padding(
      padding: EdgeInsets.fromLTRB(kTogglePadding, 0, kTogglePadding, 0),
      child: Text('Accent', style: TextStyle(fontSize: kToggleFontSize)),
    ),
    const Padding(
      padding: EdgeInsets.fromLTRB(kTogglePadding, 0, kTogglePadding, 0),
      child: Text('Black &\nWhite',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: kToggleFontSize)),
    ),
    const Padding(
      padding: EdgeInsets.fromLTRB(kTogglePadding, 0, kTogglePadding, 0),
      child: Text('Custom ', style: TextStyle(fontSize: kToggleFontSize)),
    ),
    const Padding(
      padding: EdgeInsets.fromLTRB(kTogglePadding, 0, kTogglePadding, 0),
      child: Text('Any\ncolor', style: TextStyle(fontSize: kToggleFontSize)),
    ),
  ];

  final List<bool> toggleButtonIsSelected = swatchAvailable.values.toList();

  // Define some custom colors to be used in the custom segment.
  static const Color googleNewPrimary = Color(0xFF6200EE);
  static const Color googleNewPrimaryVariant = Color(0xFF3700B3);
  static const Color googleNewSecondary = Color(0xFF03DAC6);
  static const Color googleNewSecondaryVariant = Color(0xFF018786);
  static const Color googleNewError = Color(0xFFB00020);
  static const Color googleNewErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);
  static const Color clearBlue = Color(0xFF3db5e0);
  static const Color darkPink = Color(0xFFa33e94);
  static const Color redWine = Color(0xFFad0c1c);
  static const Color grassGreen = Color(0xFF3bb87f);
  static const Color moneyGreen = Color(0xFF869962);
  static const Color mandarinOrange = Color(0xFFdb7a25);
  static const Color brightOrange = Color(0xFFff5319);
  static const Color brightGreen = Color(0xFF00ab25);
  static const Color blueJean = Color(0xFF4f75b8);
  static const Color deepBlueSea = Color(0xFF132b80);

  // Make a custom color swatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimaryColor(googleNewPrimary): 'G Purple',
    ColorTools.createPrimaryColor(googleNewPrimaryVariant): 'G Purple Variant',
    ColorTools.createAccentColor(googleNewSecondary): 'G Teal',
    ColorTools.createAccentColor(googleNewSecondaryVariant): 'G Teal Variant',
    ColorTools.createPrimaryColor(googleNewError): 'G Error',
    ColorTools.createPrimaryColor(googleNewErrorDark): 'G Error Dark',
    ColorTools.createPrimaryColor(blueBlues): 'Blue blues',
    ColorTools.createPrimaryColor(clearBlue): 'Clear blue',
    ColorTools.createPrimaryColor(darkPink): 'Dark pink',
    ColorTools.createPrimaryColor(redWine): 'Red wine',
    ColorTools.createPrimaryColor(grassGreen): 'Grass green',
    ColorTools.createPrimaryColor(moneyGreen): 'Money green',
    ColorTools.createPrimaryColor(mandarinOrange): 'Mandarin orange',
    ColorTools.createPrimaryColor(brightOrange): 'Bright orange',
    ColorTools.createPrimaryColor(brightGreen): 'Bright green',
    ColorTools.createPrimaryColor(blueJean): 'Washed jean blue',
    ColorTools.createPrimaryColor(deepBlueSea): 'Deep blue sea',
  };

  @override
  void initState() {
    // To get a color show up as selected by default when calling the picker
    // start with a given color in a Swatch, not just with a Swatch, like
    // Colors.blue or Colors.red, the color will not get pre-selected in the
    // picker then.
    screenPickerColor = Colors.blue[500];
    dialogPickerColor = Colors.red[800];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'ColorPicker Demo',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxBodyWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // This spacing adds back the top safe area that we loose with
                  // extendBodyBehindAppBar = true and the AppBar, we will now
                  // see the content that scroll behind the semi transparent appbar
                  SizedBox(
                      height:
                          MediaQuery.of(context).padding.top + kToolbarHeight),
                  // Color picker demo in a raised card
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Card(
                        elevation: 1,
                        child: ColorPicker(
                          color: screenPickerColor,
                          onColorChanged: (Color color) =>
                              setState(() => screenPickerColor = color),
                          selectShades: selectShadeColors,
                          includeIndex850: includeIndex850,
                          showNameSelected: showColorName,
                          crossAxisAlignment: centerContent
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          size: size,
                          borderRadius: borderRadius,
                          hasBorder: useBorder,
                          hasWheelBorder: useBorderWheel,
                          elevation: elevation,
                          padding: padding,
                          spacing: spacing,
                          runSpacing: runSpacing,
                          heading: showHeading
                              ? Text(
                                  'Select color',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              : null,
                          subHeading: showSubHeading
                              ? Text(
                                  'Select color shade',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              : null,
                          subWheelHeading: showSubHeading
                              ? Text(
                                  'Selected color and its material shades',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              : null,
                          swatchAvailable: swatchAvailable,
                          // The name map is used to give the custom colors names
                          colorSwatchNameMap: colorsNameMap,
                          wheelSize: wheelSize,
                          wheelWidth: wheelWidth,
                        ),
                      ),
                    ),
                  ),

                  // Show the selected color
                  ListTile(
                    title:
                        const Text('Select color above to change this color'),
                    subtitle: Text(
                      ColorTools.colorNameAndHexCode(
                        screenPickerColor,
                        colorSwatchNameMap: colorsNameMap,
                      ),
                    ),
                    trailing: ColorIndicator(
                      height: size,
                      width: size,
                      borderRadius: borderRadius,
                      elevation: elevation,
                      color: screenPickerColor,
                      hasBorder: useBorder,
                    ),
                  ),

                  // Show the selected color
                  ListTile(
                    title:
                        const Text('Click this color to change it in a dialog'),
                    subtitle: Text(
                      ColorTools.colorNameAndHexCode(
                        dialogPickerColor,
                        colorSwatchNameMap: colorsNameMap,
                      ),
                    ),
                    trailing: ColorIndicator(
                      height: size,
                      width: size,
                      borderRadius: borderRadius,
                      elevation: elevation,
                      color: dialogPickerColor,
                      hasBorder: useBorder,
                      onSelect: () async {
                        final Color _colorBeforeDialog = dialogPickerColor;
                        if (!(await colorPickerDialog())) {
                          setState(() {
                            dialogPickerColor = _colorBeforeDialog;
                          });
                        }
                      },
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 0, 14),
                    child: Text(
                      'Customize the Color Picker',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),

                  ListTile(
                    title: const Text(
                        'Select colors swatches to use in the picker'),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ToggleButtons(
                            onPressed: (int index) {
                              // ToggleButtons is cool, you can do custom
                              // toggle logic
                              setState(() {
                                toggleButtonIsSelected[index] =
                                    !toggleButtonIsSelected[index];
                                if (index == 0) {
                                  swatchAvailable[ColorPickerSwatch.both] =
                                      toggleButtonIsSelected[index];
                                  // If 'Both' is on then Material and Accent are off
                                  if (swatchAvailable[ColorPickerSwatch.both]) {
                                    toggleButtonIsSelected[1] = false;
                                    swatchAvailable[
                                        ColorPickerSwatch.material] = false;
                                    toggleButtonIsSelected[2] = false;
                                    swatchAvailable[ColorPickerSwatch.accent] =
                                        false;
                                  }
                                }
                                if (index == 1) {
                                  swatchAvailable[ColorPickerSwatch.material] =
                                      toggleButtonIsSelected[index];
                                  // If we turned on 'Material', we turn of 'Both'
                                  if (swatchAvailable[
                                      ColorPickerSwatch.material]) {
                                    toggleButtonIsSelected[0] = false;
                                    swatchAvailable[ColorPickerSwatch.both] =
                                        false;
                                  }
                                }
                                if (index == 2) {
                                  swatchAvailable[ColorPickerSwatch.accent] =
                                      toggleButtonIsSelected[index];
                                  // If we turned on 'Material', we turn of 'Both'
                                  if (swatchAvailable[
                                      ColorPickerSwatch.accent]) {
                                    toggleButtonIsSelected[0] = false;
                                    swatchAvailable[ColorPickerSwatch.both] =
                                        false;
                                  }
                                }
                                if (index == 3) {
                                  swatchAvailable[ColorPickerSwatch.bw] =
                                      toggleButtonIsSelected[index];
                                }
                                if (index == 4) {
                                  swatchAvailable[ColorPickerSwatch.custom] =
                                      toggleButtonIsSelected[index];
                                }
                                if (index == 5) {
                                  swatchAvailable[ColorPickerSwatch.any] =
                                      toggleButtonIsSelected[index];
                                }
                              });
                            },
                            isSelected: toggleButtonIsSelected,
                            color: Theme.of(context).primaryColorDark,
                            fillColor: Theme.of(context).primaryColorDark,
                            selectedColor: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(10),
                            borderWidth: 2,
                            borderColor: Theme.of(context).primaryColor,
                            selectedBorderColor: Theme.of(context).primaryColor,
                            hoverColor: Theme.of(context).primaryColorLight,
                            focusColor: Theme.of(context).primaryColorDark,
                            children: toggleButtons,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Enable shades selection'),
                    subtitle: const Text(
                        'If this is off, you can only select the main '
                        'color in a color swatch'),
                    value: selectShadeColors,
                    onChanged: (bool value) =>
                        setState(() => selectShadeColors = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Include grey color index 850'),
                    subtitle: const Text(
                        'To include the not so well known 850 color in '
                        'the Grey swatch, turn on this'),
                    value: includeIndex850,
                    onChanged: (bool value) =>
                        setState(() => includeIndex850 = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Center content'),
                    subtitle: const Text('Keep OFF for left aligned'),
                    value: centerContent,
                    onChanged: (bool value) =>
                        setState(() => centerContent = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Show selected color name and code'),
                    subtitle: const Text(
                        'If color has a material name it is shown along '
                        'with shade index and Flutter HEX code'),
                    value: showColorName,
                    onChanged: (bool value) =>
                        setState(() => showColorName = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Show heading text'),
                    subtitle: const Text(
                        'You can provide your own heading widget, if '
                        'it is null there is no heading'),
                    value: showHeading,
                    onChanged: (bool value) =>
                        setState(() => showHeading = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Show sub heading text'),
                    subtitle: const Text(
                        'You can provide your own sub heading widget, if '
                        'it is null there is no sub heading'),
                    value: showSubHeading,
                    onChanged: (bool value) =>
                        setState(() => showSubHeading = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Border around color pick items'),
                    subtitle: const Text('With the API you can also adjust the '
                        'border color'),
                    value: useBorder,
                    onChanged: (bool value) =>
                        setState(() => useBorder = value),
                  ),

                  SwitchListTile.adaptive(
                    title: const Text('Border around color wheel'),
                    subtitle: const Text('With the API you can also adjust the '
                        'border color'),
                    value: useBorderWheel,
                    onChanged: (bool value) =>
                        setState(() => useBorderWheel = value),
                  ),

                  // Color picker size
                  ListTile(
                    title: const Text('Color picker item size'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          min: sizeMin,
                          max: sizeMax,
                          divisions: (sizeMax - sizeMin).floor(),
                          label: size.floor().toString(),
                          value: size,
                          onChanged: (double value) {
                            if (value / 2 < borderRadius) {
                              borderRadius = value / 2;
                            }
                            setState(() => size = value);
                          },
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            size.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Border radius
                  ListTile(
                    title: const Text('Color picker item border radius'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          max: size / 2,
                          divisions: (size / 2).floor(),
                          label: borderRadius.floor().toString(),
                          value: borderRadius,
                          onChanged: (double value) =>
                              setState(() => borderRadius = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            borderRadius.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Elevation of color pick item
                  ListTile(
                    title: const Text('Color picker item elevation'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          max: 16,
                          divisions: 16,
                          label: elevation.floor().toString(),
                          value: elevation,
                          onChanged: (double value) =>
                              setState(() => elevation = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            elevation.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Spacing of color pick items
                  ListTile(
                    title: const Text('Color picker item spacing'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          max: 25,
                          divisions: 25,
                          label: spacing.floor().toString(),
                          value: spacing,
                          onChanged: (double value) =>
                              setState(() => spacing = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            spacing.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Run spacing of color pick items
                  ListTile(
                    title: const Text('Color picker item run spacing'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          max: 25,
                          divisions: 25,
                          label: runSpacing.floor().toString(),
                          value: runSpacing,
                          onChanged: (double value) =>
                              setState(() => runSpacing = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            runSpacing.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Run spacing of color pick items
                  ListTile(
                    title: const Text('Color picker content padding'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          max: 40,
                          divisions: 40,
                          label: padding.floor().toString(),
                          value: padding,
                          onChanged: (double value) =>
                              setState(() => padding = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            padding.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Wheel size selector
                  ListTile(
                    title: const Text('Color wheel size'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          min: 150,
                          max: 500,
                          divisions: 40,
                          label: wheelSize.floor().toString(),
                          value: wheelSize,
                          onChanged: (double value) =>
                              setState(() => wheelSize = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            wheelSize.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Wheel width selector
                  ListTile(
                    title: const Text('Color wheel width'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Slider.adaptive(
                          min: 4,
                          max: 50,
                          label: wheelWidth.floor().toString(),
                          value: wheelWidth,
                          onChanged: (double value) =>
                              setState(() => wheelWidth = value),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'px',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            wheelWidth.floor().toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      selectShades: selectShadeColors,
      includeIndex850: includeIndex850,
      showNameSelected: showColorName,
      crossAxisAlignment:
          centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      size: size,
      borderRadius: borderRadius,
      hasBorder: useBorder,
      hasWheelBorder: useBorderWheel,
      elevation: elevation,
      padding: padding,
      spacing: spacing,
      runSpacing: runSpacing,
      heading: showHeading
          ? Text(
              'Select color',
              style: Theme.of(context).textTheme.subtitle1,
            )
          : null,
      subHeading: showSubHeading
          ? Text(
              'Select color shade',
              style: Theme.of(context).textTheme.subtitle1,
            )
          : null,
      subWheelHeading: showSubHeading
          ? Text(
              'Selected color and its material shades',
              style: Theme.of(context).textTheme.subtitle1,
            )
          : null,
      swatchAvailable: swatchAvailable,
      colorSwatchNameMap: colorsNameMap,
      wheelSize: wheelSize,
      wheelWidth: wheelWidth,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 475, minWidth: 480, maxWidth: 480),
    );
  }
}
