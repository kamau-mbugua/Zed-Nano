/// A generic response model for standardizing API responses
class ResponseModel<T> {

  ResponseModel(this._isSuccess, this._message, [this._data]);
  final bool _isSuccess;
  final String _message;
  final T? _data;

  String? get message => _message;
  bool get isSuccess => _isSuccess;

  T? get data => _data;
}
