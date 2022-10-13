# Manuscript Preprint Template

This is a Quarto template that assists you in creating a manuscript for 
submission to a preprint server or journal.

## Creating a New Article

To create a new manuscript, use the following command:

```bash
quarto use template kelly-sovacool/quarto-manuscript
```

This will install the extension and create an example qmd file and bibiography that you can use as a starting place for your article.

## Installation For Existing Document

You may also use this format with an existing Quarto project or document. From the quarto project or document directory, run the following command to install this format:

```bash
quarto install extension kelly-sovacool/quarto-manuscript
```

## Usage

To use the format, you can use the format names `manuscript-pdf` and `manuscript-html`. For example:

```bash
quarto render article.qmd --to manuscript-pdf
```

or in your document yaml

```yaml
format:
  pdf: default
  manuscript-pdf:
    keep-tex: true    
```

You can view a preview of the rendered template at <https://quartopub.com/sites/kelly-sovacool/manuscript-preprint-template>.
