def get_perfil(request):
    if hasattr(request.user, "perfil"):
        return request.user.perfil