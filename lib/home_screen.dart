import 'dart:io';
import 'package:contact_app/contact_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  File? selectedImage;

  String username = 'username';
  String phone = 'phone';
  String email = 'Email';

  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xff29384D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: screenWidth * 0.35, // Responsive logo size
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: contacts.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/empty.gif",
                            width: screenWidth * 0.6,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "There are no contacts added yet.",
                            style: TextStyle(
                              color: Color(0xffFFF1D4),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        itemCount: contacts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // Adjust grid based on width
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.52,
                        ),
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffFFF1D4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(16),
                                      ),
                                      child: Image.file(
                                        contact.image,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5.0,
                                      left: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFF1D4),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          contact.name,
                                          style: const TextStyle(
                                            color: Color(0xff29384D),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/email.svg",
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          contact.email,
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/phone.svg",
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          contact.phone,
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        contacts.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: const Color(0xffFFF1D4),
            onPressed: () async {
              final newContact = await addContact(context);
              if (newContact != null) {
                setState(() {
                  contacts.add(newContact);
                });
              }
            },
            child: const Icon(Icons.add, color: Color(0xff29384D)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'delete',
            backgroundColor: const Color(0xffFFF1D4),
            onPressed: () {
              setState(() {
                contacts.clear();
              });
            },
            child: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<Contact?> addContact(BuildContext context) async {
    File? localImage = selectedImage;
    return await showModalBottomSheet<Contact>(
      backgroundColor: const Color(0xff29384D),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final img = await openGallery();
                            if (img != null) {
                              setModalState(() {
                                localImage = img;
                              });
                              setState(() {
                                selectedImage = img;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffFFF1D4),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: localImage != null
                                  ? Image.file(
                                      localImage!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/image.gif",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Color(0xffFFF1D4),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              Divider(color: Color(0xffFFF1D4), thickness: 1),
                              const SizedBox(height: 8),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Color(0xffFFF1D4),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              Divider(color: Color(0xffFFF1D4), thickness: 1),
                              const SizedBox(height: 8),
                              Text(
                                phone,
                                style: const TextStyle(
                                  color: Color(0xffFFF1D4),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      style: const TextStyle(color: Color(0xffE2F4F6)),
                      decoration: inputDecoration("Username"),
                      cursorColor: const Color(0xffE2F4F6),
                      onChanged: (value) {
                        setModalState(() {
                          username = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Color(0xffE2F4F6)),
                      decoration: inputDecoration("User Email"),
                      cursorColor: const Color(0xffE2F4F6),
                      onChanged: (value) {
                        setModalState(() {
                          email = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      style: const TextStyle(color: Color(0xffE2F4F6)),
                      decoration: inputDecoration("User Phone"),
                      onChanged: (value) {
                        setModalState(() {
                          phone = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      cursorColor: const Color(0xffE2F4F6),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text(
                            "Enter user",
                            style: TextStyle(
                              color: Color(0xff29384D),
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFF1D4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (usernameController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty ||
                                phoneController.text.trim().isEmpty ||
                                localImage == null) {
                              return;
                            }

                            final contact = Contact(
                              name: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              image: localImage!,
                            );

                            usernameController.clear();
                            emailController.clear();
                            phoneController.clear();
                            selectedImage = null;
                            username = "username";
                            email = "Email";
                            phone = "phone";

                            Navigator.pop(context, contact);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xffFFF1D4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xffFFF1D4)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xffFFF1D4), width: 2),
    ),
    filled: true,
    fillColor: const Color(0xff29384D),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  );

  Future<File?> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
