/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/Buffer.h
 *  The original licence follows this statement
 */

/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */
 
module bindbc.diligent.graphics.buffer;

import bindbc.diligent.graphics.deviceobject;
import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.bufferview;

// {EC47EAD3-A2C4-44F2-81C5-5248D14F10E4}
static const INTERFACE_ID IID_Buffer = 
    INTERFACE_ID(0xec47ead3, 0xa2c4, 0x44f2, [0x81, 0xc5, 0x52, 0x48, 0xd1, 0x4f, 0x10, 0xe4]);

/// Describes the buffer access mode.

/// This enumeration is used by BufferDesc structure.
enum BUFFER_MODE : ubyte
{
    /// Undefined mode.
    BUFFER_MODE_UNDEFINED = 0,

    /// Formatted buffer. Access to the buffer will use format conversion operations.
    /// In this mode, ElementByteStride member of BufferDesc defines the buffer element size.
    /// Buffer views can use different formats, but the format size must match ElementByteStride.
    BUFFER_MODE_FORMATTED,

    /// Structured buffer.
    /// In this mode, ElementByteStride member of BufferDesc defines the structure stride.
    BUFFER_MODE_STRUCTURED,

    /// Raw buffer.
    /// In this mode, the buffer is accessed as raw bytes. Formatted views of a raw
    /// buffer can also be created similar to formatted buffer. If formatted views
    /// are to be created, the ElementByteStride member of BufferDesc must specify the
    /// size of the format.
    BUFFER_MODE_RAW,

    /// Helper value storing the total number of modes in the enumeration.
    BUFFER_MODE_NUM_MODES
}

/// Buffer description
struct BufferDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Size of the buffer, in bytes. For a uniform buffer, this must be multiple of 16.
    uint uiSizeInBytes = 0;

    /// Buffer bind flags, see Diligent::BIND_FLAGS for details

    /// The following bind flags are allowed:
    /// Diligent::BIND_VERTEX_BUFFER, Diligent::BIND_INDEX_BUFFER, Diligent::BIND_UNIFORM_BUFFER,
    /// Diligent::BIND_SHADER_RESOURCE, Diligent::BIND_STREAM_OUTPUT, Diligent::BIND_UNORDERED_ACCESS,
    /// Diligent::BIND_INDIRECT_DRAW_ARGS, Diligent::BIND_RAY_TRACING
    BIND_FLAGS BindFlags = BIND_FLAGS.BIND_NONE;

    /// Buffer usage, see Diligent::USAGE for details
    USAGE Usage = USAGE.USAGE_DEFAULT;

    /// CPU access flags or 0 if no CPU access is allowed, 
    /// see Diligent::CPU_ACCESS_FLAGS for details.
    CPU_ACCESS_FLAGS CPUAccessFlags = CPU_ACCESS_FLAGS.CPU_ACCESS_NONE;

    /// Buffer mode, see Diligent::BUFFER_MODE
    BUFFER_MODE Mode = BUFFER_MODE.BUFFER_MODE_UNDEFINED;

    /// Buffer element stride, in bytes.

    /// For a structured buffer (BufferDesc::Mode equals Diligent::BUFFER_MODE_STRUCTURED) this member 
    /// defines the size of each buffer element. For a formatted buffer
    /// (BufferDesc::Mode equals Diligent::BUFFER_MODE_FORMATTED) and optionally for a raw buffer 
    /// (Diligent::BUFFER_MODE_RAW), this member defines the size of the format that will be used for views 
    /// created for this buffer.
    uint ElementByteStride = 0;

    /// Defines which immediate contexts are allowed to execute commands that use this buffer.

    /// When ImmediateContextMask contains a bit at position n, the buffer may be
    /// used in the immediate context with index n directly (see DeviceContextDesc::ContextId).
    /// It may also be used in a command list recorded by a deferred context that will be executed
    /// through that immediate context.
    ///
    /// \remarks    Only specify these bits that will indicate those immediate contexts where the buffer
    ///             will actually be used. Do not set unncessary bits as this will result in extra overhead.
    ulong ImmediateContextMask = 1;
}

/// Describes the buffer initial data
struct BufferData
{
    /// Pointer to the data
    const void* pData = null;

    /// Data size, in bytes
    uint DataSize = 0;

    /// Defines which device context will be used to initialize the buffer.

    /// The buffer will be in write state after the initialization.
    /// If an application uses the buffer in another context afterwards, it
    /// must synchronize the access to the buffer using fence.
    /// When null is provided, the first context enabled by ImmediateContextMask
    /// will be used.
    IDeviceContext* pContext = null;
}

/// Buffer interface

/// Defines the methods to manipulate a buffer object
struct IBufferMethods
{
    extern(C) @nogc nothrow {
        /// Creates a new buffer view

        /// \param [in] ViewDesc - View description. See Diligent::BufferViewDesc for details.
        /// \param [out] ppView - Address of the memory location where the pointer to the view interface will be written to.
        ///
        /// \remarks To create a view addressing the entire buffer, set only BufferViewDesc::ViewType member
        ///          of the ViewDesc structure and leave all other members in their default values.\n
        ///          Buffer view will contain strong reference to the buffer, so the buffer will not be destroyed
        ///          until all views are released.\n
        ///          The function calls AddRef() for the created interface, so it must be released by
        ///          a call to Release() when it is no longer needed.
        void* CreateView(IBuffer*, const BufferViewDesc* ViewDesc, IBufferView** ppView);

        /// Returns the pointer to the default view.

        /// \param [in] ViewType - Type of the requested view. See Diligent::BUFFER_VIEW_TYPE.
        /// \return Pointer to the interface
        ///
        /// \remarks Default views are only created for structured and raw buffers. As for formatted buffers
        ///          the view format is unknown at buffer initialization time, no default views are created.
        ///
        /// \note The function does not increase the reference counter for the returned interface, so
        ///       Release() must *NOT* be called.
        IBufferView** GetDefaultView(IBuffer*, BUFFER_VIEW_TYPE ViewType);

        /// Returns native buffer handle specific to the underlying graphics API

        /// \return pointer to ID3D11Resource interface, for D3D11 implementation\n
        ///         pointer to ID3D12Resource interface, for D3D12 implementation\n
        ///         GL buffer handle, for GL implementation
        void** GetNativeHandle(IBuffer*);

        /// Sets the buffer usage state.

        /// \note This method does not perform state transition, but
        ///       resets the internal buffer state to the given value.
        ///       This method should be used after the application finished
        ///       manually managing the buffer state and wants to hand over
        ///       state management back to the engine.
        void* SetState(IBuffer*, RESOURCE_STATE State);

        /// Returns the internal buffer state
        RESOURCE_STATE* GetState(IBuffer*);


        /// Returns the buffer memory properties, see Diligent::MEMORY_PROPERTIES.

        /// The memory properties are only relevant for persistently mapped buffers.
        /// In particular, if the memory is not coherent, an application must call
        /// IBuffer::FlushMappedRange() to make writes by the CPU available to the GPU, and
        /// call IBuffer::InvalidateMappedRange() to make writes by the GPU visible to the CPU.
        MEMORY_PROPERTIES* GetMemoryProperties(IBuffer*);


        /// Flushes the specified range of non-coherent memory from the host cache to make
        /// it available to the GPU.

        /// \param [in] StartOffset - Offset, in bytes, from the beginning of the buffer to
        ///                           the start of the memory range to flush.
        /// \param [in] Size        - Size, in bytes, of the memory range to flush.
        ///
        /// This method should only be used for persistently-mapped buffers that do not
        /// report MEMORY_PROPERTY_HOST_COHERENT property. After an application modifies
        /// a mapped memory range on the CPU, it must flush the range to make it available
        /// to the GPU.
        ///
        /// \note   This method must never be used for USAGE_DYNAMIC buffers.
        ///
        ///         When a mapped buffer is unmapped it is automatically flushed by
        ///         the engine if necessary.
        void* FlushMappedRange(IBuffer*, uint StartOffset, uint Size);


        /// Invalidates the specified range of non-coherent memory modified by the GPU to make
        /// it visible to the CPU.

        /// \param [in] StartOffset - Offset, in bytes, from the beginning of the buffer to
        ///                           the start of the memory range to invalidate.
        /// \param [in] Size        - Size, in bytes, of the memory range to invalidate.
        ///
        /// This method should only be used for persistently-mapped buffers that do not
        /// report MEMORY_PROPERTY_HOST_COHERENT property. After an application modifies
        /// a mapped memory range on the GPU, it must invalidate the range to make it visible
        /// to the CPU.
        ///
        /// \note   This method must never be used for USAGE_DYNAMIC buffers.
        ///
        ///         When a mapped buffer is unmapped it is automatically invalidated by
        ///         the engine if necessary.
        void* InvalidateMappedRange(IBuffer*, uint StartOffset, uint Size);
    }
}

struct IBufferVtbl { IBufferMethods Buffer; }
struct IBuffer { IBufferVtbl* pVtbl; }

BufferDesc* IBuffer_GetDesc(IBuffer* object){
    return cast(const BufferDesc*)IDeviceObject_GetDesc(object);
}

//#    define IBuffer_CreateView(This, ...)            CALL_IFACE_METHOD(Buffer, CreateView,            This, __VA_ARGS__)
//#    define IBuffer_GetDefaultView(This, ...)        CALL_IFACE_METHOD(Buffer, GetDefaultView,        This, __VA_ARGS__)
//#    define IBuffer_GetNativeHandle(This)            CALL_IFACE_METHOD(Buffer, GetNativeHandle,       This)
//#    define IBuffer_SetState(This, ...)              CALL_IFACE_METHOD(Buffer, SetState,              This, __VA_ARGS__)
//#    define IBuffer_GetState(This)                   CALL_IFACE_METHOD(Buffer, GetState,              This)
//#    define IBuffer_GetMemoryProperties(This)        CALL_IFACE_METHOD(Buffer, GetMemoryProperties,   This)
//#    define IBuffer_FlushMappedRange(This, ...)      CALL_IFACE_METHOD(Buffer, FlushMappedRange,      This, __VA_ARGS__)
//#    define IBuffer_InvalidateMappedRange(This, ...) CALL_IFACE_METHOD(Buffer, InvalidateMappedRange, This, __VA_ARGS__)

void* IBuffer_CreateView(IBuffer* object, const BufferViewDesc* ViewDesc, IBufferView** ppView) {
    object.pVtbl.Buffer.CreateView(object, ViewDesc, ppView);
}

IBufferView** IBuffer_GetDefaultView(IBuffer* object, BUFFER_VIEW_TYPE ViewType) {
    return object.pVtbl.Buffer.GetDefaultView(object, ViewType);
}

void** IBuffer_GetNativeHandle() {

}

void* IBuffer_SetState() {

}

RESOURCE_STATE* IBuffer_GetState() {

}

MEMORY_PROPERTIES* IBuffer_GetMemoryProperties() {

}

void* IBuffer_FlushMappedRange(){

}

void* IBuffer_InvalidateMappedRange() {

}