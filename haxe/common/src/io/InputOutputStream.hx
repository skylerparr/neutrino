package io;

import io.InputStream;
import io.OutputStream;

interface InputOutputStream extends InputStream extends OutputStream {
    function send(data: String): Void;
}
