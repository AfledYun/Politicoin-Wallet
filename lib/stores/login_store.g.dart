// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on LoginStoreBase, Store {
  final _$nameAtom = Atom(name: 'LoginStoreBase.name');

  @override
  String get name {
    _$nameAtom.context.enforceReadPolicy(_$nameAtom);
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.conditionallyRunInAction(() {
      super.name = value;
      _$nameAtom.reportChanged();
    }, _$nameAtom, name: '${_$nameAtom.name}_set');
  }

  final _$emailAtom = Atom(name: 'LoginStoreBase.email');

  @override
  String get email {
    _$emailAtom.context.enforceReadPolicy(_$emailAtom);
    _$emailAtom.reportObserved();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.context.conditionallyRunInAction(() {
      super.email = value;
      _$emailAtom.reportChanged();
    }, _$emailAtom, name: '${_$emailAtom.name}_set');
  }

  final _$imageUrlAtom = Atom(name: 'LoginStoreBase.imageUrl');

  @override
  String get imageUrl {
    _$imageUrlAtom.context.enforceReadPolicy(_$imageUrlAtom);
    _$imageUrlAtom.reportObserved();
    return super.imageUrl;
  }

  @override
  set imageUrl(String value) {
    _$imageUrlAtom.context.conditionallyRunInAction(() {
      super.imageUrl = value;
      _$imageUrlAtom.reportChanged();
    }, _$imageUrlAtom, name: '${_$imageUrlAtom.name}_set');
  }

  @override
  String toString() {
    final string =
        'name: ${name.toString()},email: ${email.toString()},imageUrl: ${imageUrl.toString()}';
    return '{$string}';
  }
}
