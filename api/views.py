from django.shortcuts import render
from rest_framework import views
from rest_framework.response import Response
from rest_framework import generics
from rest_framework import permissions
from api.serializers import TodoListSerializer, TodoItemSerializer
from tasks.models import TodoList, TodoItem
from api.permissions import IsOwner, IsListOwner
from rest_framework import viewsets
# Create your views here.

class TodoListListCreateView(generics.ListCreateAPIView):
    serializer_class = TodoListSerializer
    queryset = TodoList.objects.all()
    permission_classes = [permissions.IsAuthenticated]

    def filter_queryset(self, queryset):
        return queryset.filter(owner = self.request.user)

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

class TodoListRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = TodoListSerializer
    queryset = TodoList.objects.all()
    permission_classes = [permissions.IsAuthenticated,IsOwner]

class TodoItemViewset(viewsets.ModelViewSet):
    serializer_class = TodoItemSerializer
    queryset = TodoItem.objects.all()
    permission_classes = [permissions.IsAuthenticated,IsListOwner]

    def filter_queryset(self, queryset):
        return queryset.filter(todo_list__owner=self.request.user)