import 'package:dipetakan/features/navigation/controllers/update_email_controller.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({super.key});

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Edit Email',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DSizes.defaultSpace),
          child: Form(
            key: controller.updateEmailFormKey,
            child: Column(children: <Widget>[
              Text('Masukkan Email Lama dan Password Lama',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Email Lama
              TextFormField(
                controller: controller.oldEmail,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Email Lama'),
              ),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Password
              Obx(
                () => TextFormField(
                  controller: controller.oldPassword,
                  validator: (value) =>
                      TValidator.validateEmptyText('Password', value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.password_check),
                    labelText: DTexts.password,
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: DSizes.spaceBtwSections),
              Text('Masukkan Email Baru',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Email baru
              TextFormField(
                controller: controller.newEmail,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Email Baru'),
              ),

              const SizedBox(height: DSizes.spaceBtwSections),

              //Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.updateEmail(),
                    child: const Text('Ubah')),
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
            ]),
          ),
        ),
      ),
    );
  }
}
