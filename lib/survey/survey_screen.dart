import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../viewmodels/survey_viewmodel.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  Future<void> sendEmail(
  SurveyViewModel provider,
  ) async {

    String body = "";

    for (var question in provider.questions) {

      body +=
          "${question.question}\n"
          "Respuesta: ${provider.answers[question.id]}\n\n";
    }

    final String subject =
        Uri.encodeComponent(
          "Evaluación STUDYTRACK",
        );

    final String encodedBody =
        Uri.encodeComponent(body);

    final Uri emailUri = Uri.parse(
      "mailto:elbastian2003@gmail.com"
      "?subject=$subject"
      "&body=$encodedBody",
    );

    await launchUrl(emailUri);
}

  @override
  Widget build(BuildContext context) {

    final provider =
        Provider.of<SurveyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Evaluación STUDYTRACK",
        ),
      ),

      body: provider.questions.isEmpty

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount:
                        provider.questions.length,

                    itemBuilder:
                        (context, index) {

                      final question =
                          provider.questions[index];

                      return Card(
                        margin:
                            const EdgeInsets.all(
                                12),

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                                  16),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                question.question,
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,

                                children:
                                    List.generate(
                                  question.max - question.min + 1,

                                  (value) {

                                    final option =
                                        question.min + value;

                                    return Column(
                                      children: [

                                        Text(
                                          option
                                              .toString(),
                                        ),

                                        Radio<int>(
                                          value:
                                              option,

                                          groupValue:
                                              provider.answers[
                                                  question
                                                      .id],

                                          onChanged:
                                              (selected) {

                                            provider
                                                .setAnswer(
                                              question
                                                  .id,

                                              selected!,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: SizedBox(
                    width:
                        double.infinity,

                    child: ElevatedButton(
                      onPressed:
                          provider.allAnswered

                              ? () =>
                                  sendEmail(
                                    provider,
                                  )

                              : null,

                      child: const Text(
                        "Enviar",
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}