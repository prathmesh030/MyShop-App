import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceNode = FocusNode();
  final _descNode = FocusNode();
  final _imgUrlNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _editedProduct =
      Product(id: null, title: '', description: '', imgURL: '', price: 0.0);

  final _form = GlobalKey<FormState>();
  var isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    _imgUrlNode.addListener(updateImgUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imgUrlNode.removeListener(updateImgUrl);
    _priceNode.dispose();
    _descNode.dispose();
    _imageUrlController.dispose();
    _imgUrlNode.dispose();

    super.dispose();
  }

  var _initValues = {
    'title': '',
    'price': '',
    'imgUrl': '',
    'description': '',
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;

      if (productID != null) {
        _editedProduct = Provider.of<Products>(context).findById(productID);

        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imgUrl': '',
        };
        _imageUrlController.text = _editedProduct.imgURL;
      }
    }
    isInit = false;

    super.didChangeDependencies();
  }

  void updateImgUrl() {
    if (!_imgUrlNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) &&
          (!_imageUrlController.text.endsWith("png") &&
              !_imageUrlController.text.endsWith("jpg") &&
              !_imageUrlController.text.endsWith("jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateExistingProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addNewProduct(_editedProduct);
      } catch (err) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error Occured!"),
                  content: Text("Something went wrong"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay")),
                  ],
                ));
      }
    }

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id == null
            ? Text("Create New Product")
            : Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceNode);
                      },
                      validator: (title) {
                        if (title.isEmpty) {
                          return "Please enter a title.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          description: _editedProduct.description,
                          imgURL: _editedProduct.imgURL,
                          price: _editedProduct.price,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descNode);
                      },
                      validator: (price) {
                        if (price.isEmpty) {
                          return "Please enter a price.";
                        }
                        if (double.tryParse(price) == null) {
                          return "Please enter valid price value.";
                        }
                        if (double.parse(price) <= 0) {
                          return "Price must be greater than zero.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imgURL: _editedProduct.imgURL,
                          isFavourite: _editedProduct.isFavourite,
                          price: double.parse(value),
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: "Description"),
                      focusNode: _descNode,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (desc) {
                        if (desc.isEmpty) {
                          return "Please enter a description.";
                        }
                        if (desc.length < 10) {
                          return "Description must be 10 characters long.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          imgURL: _editedProduct.imgURL,
                          price: _editedProduct.price,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                          ),
                          child: FittedBox(
                            child: _imageUrlController.text.isEmpty
                                ? Text("NO IMG")
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imgUrlNode,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          validator: (imgUrl) {
                            if (imgUrl.isEmpty) {
                              return "Please enter a URL.";
                            }
                            if (!imgUrl.startsWith("http") &&
                                !imgUrl.startsWith("https")) {
                              return "Please enter a valid URL";
                            }
                            if (!imgUrl.endsWith("png") &&
                                !imgUrl.endsWith("jpg") &&
                                !imgUrl.endsWith("jpeg")) {
                              return "Please enter valid image format(PNG, JPG, JPEG).";
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imgURL: value,
                              price: _editedProduct.price,
                              isFavourite: _editedProduct.isFavourite,
                            );
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
