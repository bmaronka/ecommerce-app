Future<void> delay(bool addDelay, [int miliseconds = 2000]) =>
    addDelay ? Future.delayed(Duration(milliseconds: miliseconds)) : Future.value();
