import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_by_qwilton/services/auth/auth_service.dart';
import 'package:messenger_by_qwilton/services/chat/chat_service.dart';
import 'mocks.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late AuthService authService;
  late ChatService chatService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();

    authService = AuthService(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );

    chatService = ChatService(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('AuthService Tests', () {
    test('signInWithEmailAndPassword успешный вход', () async {
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@test.com');
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);

      final result = await authService.signInWithEmailAndPassword(
        'test@test.com',
        'password123',
      );

      expect(result, equals(mockUserCredential));
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).called(1);
      verify(mockDocumentReference.set(any, any)).called(1);
    });

    test('signInWithEmailAndPassword ошибка при пустых данных', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: '',
        password: '',
      )).thenThrow(FirebaseAuthException(
        code: 'invalid-email',
        message: 'Email and password cannot be empty',
      ));

      expect(
        () => authService.signInWithEmailAndPassword('', ''),
        throwsA(isA<FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'invalid-email',
        )),
      );
    });

    test('createUserWithEmailAndPassword успешная регистрация', () async {
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@test.com');
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);

      final result = await authService.createUserWithEmailAndPassword(
        'test@test.com',
        'password123',
      );

      expect(result, equals(mockUserCredential));
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).called(1);
      verify(mockDocumentReference.set(any)).called(1);
    });

    test('createUserWithEmailAndPassword ошибка при пустых данных', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: '',
        password: '',
      )).thenThrow(FirebaseAuthException(
        code: 'invalid-email',
        message: 'Email and password cannot be empty',
      ));

      expect(
        () => authService.createUserWithEmailAndPassword('', ''),
        throwsA(isA<FirebaseAuthException>().having(
          (e) => e.code,
          'code',
          'invalid-email',
        )),
      );
    });

    test('signOut успешный выход', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

      await authService.signOut();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('ChatService Tests', () {
    test('sendMessage успешная отправка сообщения', () async {
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@test.com');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      when(mockFirestore.collection('chat_rooms')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('messages')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.add(any)).thenAnswer((_) async => mockDocumentReference);

      await chatService.sendMessage('receiver_uid', 'Test message');

      verify(mockCollectionReference.add(any)).called(1);
    });

    test('getMessages возвращает стрим сообщений', () {
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@test.com');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      when(mockFirestore.collection('chat_rooms')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('messages')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.orderBy('timestamp', descending: false))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));

      final stream = chatService.getMessages('user1_uid', 'user2_uid');

      expect(stream, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());
      verify(mockCollectionReference.orderBy('timestamp', descending: false)).called(1);
    });

    test('sendMessage ошибка при пустых данных', () async {
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUser.email).thenReturn('test@test.com');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      when(mockFirestore.collection('chat_rooms')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('messages')).thenReturn(mockCollectionReference);
      when(mockCollectionReference.add(any)).thenThrow(Exception('Invalid message'));

      expect(
        () => chatService.sendMessage('', ''),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid message'),
        )),
      );
    });
  });
} 