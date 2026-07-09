import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../viewmodels/survey_viewmodel.dart';
import '../../l10n/app_localizations.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  Future<void> _sendEmail(BuildContext context, SurveyViewModel provider) async {
    final l10n = AppLocalizations.of(context)!;
  final body = provider.buildEmailBody();
  final subject = Uri.encodeComponent(l10n.surveyTitle);
  final encodedBody = Uri.encodeComponent(body);

  final Uri emailUri = Uri.parse(
    'mailto:elbastian2003@gmail.com?subject=$subject&body=$encodedBody',
  );

  try {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  } catch (_) {
    // Fallback: mostrar el texto para copiar manualmente
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.surveyTitle),
          content: SingleChildScrollView(
            child: SelectableText(body), // SelectableText permite copiar
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SurveyViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.surveyTitle), 
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? const BackButton()
            : null,
      ),
      body: provider.questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Progreso
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        l10n.surveyProgress(provider.answers.length, provider.questions.length),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: provider.questions.isEmpty
                              ? 0
                              : provider.answers.length /
                                  provider.questions.length,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: provider.questions.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final question = provider.questions[index];
                      final answered = provider.answers[question.id];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: answered != null
                              ? BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.5))
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: answered != null
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: answered != null
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      question.question,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  question.max - question.min + 1,
                                  (i) {
                                    final option = question.min + i;
                                    final isSelected = answered == option;
                                    return GestureDetector(
                                      onTap: () => provider.setAnswer(
                                          question.id, option),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$option',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.surveyMinLabel(question.min),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    l10n.surveyMaxLabel(question.max),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Botón enviar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: provider.allAnswered
                          ? () => _sendEmail(context, provider)
                          : null,
                      icon: const Icon(Icons.send),
                      label: Text(
                        provider.allAnswered
                            ? l10n.surveySend // 👈 CAMBIAR
                            : l10n.surveyAnswerAll
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
