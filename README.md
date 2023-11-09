# Hardship Letter Writer

Hardship letter generator with intuitive UI,

## Amplify

This project requires AWS cloud resources provided by Amplify.

### Developer Notes

```
amplify delete // Don't because this deletes both cloud resources and all local amplify files!
```

Marmaid flowchart:

```
flowchart TD
    Q1{Institution Type}
    Q2{Perspective}
    Q3{What is the reason\nfor your financial hardship?}
    Q4{How long have you\nbeen facing this hardship?}
    Q5{What specific financial\ndifficulties are you experiencing?}
    Q6{Have you taken any actions\nto address your hardship?}
    Q7{Do you have any supporting\ndocuments for your hardship?}
    Q8{Are there any specific details\nor events related to your hardship\nthat you want to highlight in the letter?}
    Q9{Is there a specific outcome you\nhope to achieve through\nthis hardship letter?}

    Q1 --> Q2 --> Q3 --> Q4 --> Q5 --> Q6 --> Q7 --> Q8 --> Q9

```
