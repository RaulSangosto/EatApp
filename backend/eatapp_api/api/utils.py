from django.core.mail import EmailMessage, EmailMultiAlternatives
from django.template.response import SimpleTemplateResponse


# def enviar_mail(to_email, subject, body, title=None, from_email="hi@voltio.app"):
#     if not title:
#         title = subject

#     context = {
#         "base_url": "http://m.voltio.app",
#         "logo": "/static/img/logo.png",
#         "body": body,
#         "title": title,
#         "color": "#1B8BF9",
#     }
#     if not isinstance(to_email, list):
#         to_email = [to_email]

#     html = SimpleTemplateResponse("email.html", context).render().content
#     msg = EmailMultiAlternatives(subject, body, from_email, to_email, bcc=["jose@o2w.es"])
#     msg.attach_alternative(html.decode("utf-8"), "text/html")
#     msg.send()


def es_usuario(user):
    if hasattr(user, "perfil"):
        return True
    return False
