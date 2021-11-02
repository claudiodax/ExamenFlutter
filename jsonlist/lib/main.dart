import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de nombres',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: Settings(),
    );
  }
}

class Opt {
  final String ruta;
  final String icon;
  final String texto;

  const Opt(this.ruta, this.icon, this.texto);
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _MenuProvider {
  List<dynamic> opciones = [];

  Future<List<dynamic>> cargarData() async {
    final resp = await rootBundle.loadString('data/menu_opts.json');

    Map dataMap = json.decode(resp);

    opciones = dataMap['rutas'];

    return opciones;
  }
}

class _SettingsState extends State<Settings> {
  final menuProvider = _MenuProvider();

  final _icons = <String, IconData>{
    'add_alert': Icons.add_alert,
    'accessibility': Icons.accessibility,
    'folder_open': Icons.folder_open,
    'animation_outlined': Icons.animation_outlined,
    'input': Icons.input,
    'settings_rounded': Icons.settings_rounded,
    'list': Icons.list,
  };

  Icon getIcon(String nombreIcono) {
    return Icon(_icons[nombreIcono]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Cosas')));
            },
          ),
        ],
      ),
      body: _jsonSugge(),
    );
  }

  Widget _jsonSugge() {
    return FutureBuilder(
        future: menuProvider.cargarData(),
        initialData: [],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return ListView(children: _listaItems(snapshot.data!, context));
        });
  }

  List<Widget> _listaItems(List<dynamic> data, context) {
    final List<Widget> opciones = [];

    data.forEach((opt) {
      final widgetTemp = ListTile(
        title: Text(opt['texto']),
        leading: getIcon(opt['icon']),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScren(opt: opt),
            ),
          );
        },
      );
      opciones
        ..add(widgetTemp)
        ..add(Divider());
    });
    return opciones;
  }
}

class DetailsScren extends StatelessWidget {
  const DetailsScren({Key? key, required this.opt}) : super(key: key);

  final Map opt;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elestyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];
    switch (opt['ruta']) {
      case 'Alertas':
        return Scaffold(
          appBar: AppBar(
            title: Text(opt['ruta']),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: Text(opt['texto'])),
                  Center(
                      child: TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Titulo de Alerta'),
                        content: const Text('Dialogo de alerta'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Mostrar Alerta'),
                  )),
                  Center(
                    child: ElevatedButton(
                      style: elestyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  )
                ],
              )),
        );

      case 'Avatares':
        return Scaffold(
          appBar: AppBar(
            title: Text(opt['ruta']),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: Text(opt['texto'])),
                  const Center(
                      child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn.domestika.org/c_fit,dpr_auto,f_auto,t_base_params,w_820/v1588791114/content-items/004/470/041/Pixel_Art_Portrait_001-original.png?1588791114'),
                  )),
                  Center(
                    child: ElevatedButton(
                      style: elestyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  )
                ],
              )),
        );
      case 'Cartas':
        return Scaffold(
          appBar: AppBar(
            title: Text(opt['ruta']),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: Text(opt['texto'])),
                  Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.album),
                            title: Text('The Enchanted Nightingale'),
                            subtitle: Text(
                                'Music by Julie Gable. Lyrics by Sidney Stein.'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('BUY TICKETS'),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('LISTEN'),
                                onPressed: () {/* ... */},
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: elestyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  )
                ],
              )),
        );
      case 'Animaciones':
        return const AnimatedContainerApp();
      case 'Inputs':
        return Scaffold(
          appBar: AppBar(
            title: Text(opt['ruta']),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: Text(opt['texto'])),
                  const Center(
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term'),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: elestyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  )
                ],
              )),
        );
      case 'Sliders':
        return Scaffold(
          appBar: AppBar(
            title: Text(opt['ruta']),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: Text(opt['texto'])),
                  const Center(
                    child: SliderWidget(),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: elestyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  )
                ],
              )),
        );
      case 'Listas':
        return Scaffold(
          appBar: AppBar(
            title: Text(opt['ruta']),
          ),
          body: ListView(
            children: [
              Center(child: Text(opt['texto'])),
              Container(
                height: 50,
                color: Colors.amber[600],
                child: const Center(child: Text('Entry A')),
              ),
              Container(
                height: 50,
                color: Colors.amber[500],
                child: const Center(child: Text('Entry B')),
              ),
              Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry C')),
              ),
              ElevatedButton(
                style: elestyle,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        );

      default:
        return Scaffold(
          appBar: AppBar(
            title: Text('ERRROR'),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(child: Text('Algo fue mal')),
                  Center(
                    child: ElevatedButton(
                      style: elestyle,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver'),
                    ),
                  )
                ],
              )),
        );
    }
  }
}

class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({Key? key}) : super(key: key);

  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elestyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedContainer Demo'),
        ),
        body: Center(
          child: Column(
            children: [
              AnimatedContainer(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: _borderRadius,
                ),
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              ),
              Center(
                child: ElevatedButton(
                  style: elestyle,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Volver'),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              final random = Random();
              _width = random.nextInt(300).toDouble();
              _height = random.nextInt(300).toDouble();
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );
              _borderRadius =
                  BorderRadius.circular(random.nextInt(100).toDouble());
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidget();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SliderWidget extends State<SliderWidget> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 100,
      divisions: 5,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
