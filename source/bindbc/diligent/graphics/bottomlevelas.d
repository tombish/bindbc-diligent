/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
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

module bindbc.diligent.graphics.bottomlevelas;

/// \file
/// Definition of the Diligent::IBottomLevelAS interface and related data structures

import bindbc.diligent.primitives.object;
import bindbc.diligent.graphics.graphicstypes;
import bindbc.diligent.graphics.constants;
import bindbc.diligent.graphics.buffer;

// {E56F5755-FE5E-496C-BFA7-BCD535360FF7}
static const INTERFACE_ID IID_BottomLevelAS =
    INTERFACE_ID(0xe56f5755, 0xfe5e, 0x496c, [0xbf, 0xa7, 0xbc, 0xd5, 0x35, 0x36, 0xf, 0xf7]);

static const uint INVALID_INDEX = ~0u;

/// Defines bottom level acceleration structure triangles description.

/// Triangle geometry description.
struct BLASTriangleDesc
{
    /// Geometry name.
    /// The name is used to map triangle data (BLASBuildTriangleData) to this geometry.
    const(char)* GeometryName = null;

    /// The maximum vertex count in this geometry.
    /// Current number of vertices is defined in BLASBuildTriangleData::VertexCount.
    uint MaxVertexCount = 0;

    /// The type of vertices in this geometry, see Diligent::VALUE_TYPE.
    /// 
    /// \remarks Only the following values are allowed: VT_FLOAT32, VT_FLOAT16, VT_INT16.
    ///          VT_INT16 defines 16-bit signed normalized vertex components.
    VALUE_TYPE VertexValueType = VALUE_TYPE.VT_UNDEFINED;

    /// The number of components in the vertex.
    /// 
    /// \remarks Only 2 or 3 are allowed values. For 2-component formats, the third component is assumed 0.
    ubyte VertexComponentCount = 0;

    /// The maximum primitive count in this geometry.
    /// The current number of primitives is defined in BLASBuildTriangleData::PrimitiveCount.
    uint MaxPrimitiveCount = 0;

    /// Index type of this geometry, see Diligent::VALUE_TYPE.
    /// Must be VT_UINT16, VT_UINT32 or VT_UNDEFINED.
    /// If not defined then vertex array is used instead of indexed vertices.
    VALUE_TYPE IndexType = VALUE_TYPE.VT_UNDEFINED;

    /// Vulkan only, allows to use transformations in BLASBuildTriangleData.
    bool AllowsTransforms = false;
    
}

/// Defines bottom level acceleration structure axis-aligned bounding boxes description.

/// AABB geometry description.
struct BLASBoundingBoxDesc
{
    /// Geometry name.
    /// The name is used to map AABB data (BLASBuildBoundingBoxData) to this geometry.
    const(char)* GeometryName = null;
    
    /// The maximum AABB count.
    /// Current number of AABBs is defined in BLASBuildBoundingBoxData::BoxCount. 
    uint MaxBoxCount = 0;    
}

/// Defines acceleration structures build flags.
enum RAYTRACING_BUILD_AS_FLAGS : ubyte
{
    RAYTRACING_BUILD_AS_NONE              = 0,

    /// Indicates that the specified acceleration structure can be updated
    /// via IDeviceContext::BuildBLAS() or IDeviceContext::BuildTLAS().
    /// With this flag, the acceleration structure may allocate more memory and take more time to build.
    RAYTRACING_BUILD_AS_ALLOW_UPDATE      = 0x01,

    /// Indicates that the specified acceleration structure can act as the source for
    /// a copy acceleration structure command IDeviceContext::CopyBLAS() or IDeviceContext::CopyTLAS()
    /// with COPY_AS_MODE_COMPACT mode to produce a compacted acceleration structure.
    /// With this flag acculeration structure may allocate more memory and take more time on build.
    RAYTRACING_BUILD_AS_ALLOW_COMPACTION  = 0x02,

    /// Indicates that the given acceleration structure build should prioritize trace performance over build time.
    RAYTRACING_BUILD_AS_PREFER_FAST_TRACE = 0x04,

    /// Indicates that the given acceleration structure build should prioritize build time over trace performance.
    RAYTRACING_BUILD_AS_PREFER_FAST_BUILD = 0x08,

    /// Indicates that this acceleration structure should minimize the size of the scratch memory and the final
    /// result build, potentially at the expense of build time or trace performance.
    RAYTRACING_BUILD_AS_LOW_MEMORY        = 0x10,

    RAYTRACING_BUILD_AS_FLAGS_LAST        = RAYTRACING_BUILD_AS_LOW_MEMORY
}

/// Bottom-level AS description.
struct BottomLevelASDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Array of triangle geometry descriptions.
    const(BLASTriangleDesc)* pTriangles = null;

    /// The number of triangle geometries in pTriangles array.
    uint TriangleCount = 0;

    /// Array of AABB geometry descriptions.
    const(BLASBoundingBoxDesc)* pBoxes = null;

    /// The number of AABB geometries in pBoxes array.
    uint BoxCount = 0;

    /// Ray tracing build flags, see Diligent::RAYTRACING_BUILD_AS_FLAGS.
    RAYTRACING_BUILD_AS_FLAGS Flags = RAYTRACING_BUILD_AS_FLAGS.RAYTRACING_BUILD_AS_NONE;

    /// Size from the result of IDeviceContext::WriteBLASCompactedSize() if this acceleration structure
    /// is going to be the target of a compacting copy (IDeviceContext::CopyBLAS() with COPY_AS_MODE_COMPACT).
    uint CompactedSize = 0;

    /// Defines which immediate contexts are allowed to execute commands that use this BLAS.

    /// When ImmediateContextMask contains a bit at position n, the acceleration structure may be
    /// used in the immediate context with index n directly (see DeviceContextDesc::ContextId).
    /// It may also be used in a command list recorded by a deferred context that will be executed
    /// through that immediate context.
    ///
    /// \remarks    Only specify these bits that will indicate those immediate contexts where the BLAS
    ///             will actually be used. Do not set unncessary bits as this will result in extra overhead.
    ulong ImmediateContextMask = 1;

}

/// Defines the scratch buffer info for acceleration structure.
struct ScratchBufferSizes
{
    /// Scratch buffer size for acceleration structure building,
    /// see IDeviceContext::BuildBLAS(), IDeviceContext::BuildTLAS().
    /// May be zero if the acceleration structure was created with non-zero CompactedSize.
    uint Build = 0;
    
    /// Scratch buffer size for acceleration structure updating,
    /// see IDeviceContext::BuildBLAS(), IDeviceContext::BuildTLAS().
    /// May be zero if acceleration structure was created without RAYTRACING_BUILD_AS_ALLOW_UPDATE flag.
    /// May be zero if acceleration structure was created with non-zero CompactedSize.
    uint Update = 0;
    
}

/// Bottom-level AS interface

/// Defines the methods to manipulate a BLAS object
struct IBottomLevelASMethods
{
    extern(C) @nogc nothrow {
        /// Returns the geometry description index in BottomLevelASDesc::pTriangles or BottomLevelASDesc::pBoxes.

        /// \param [in] Name - Geometry name that is specified in BLASTriangleDesc or BLASBoundingBoxDesc.
        /// \return Geometry index or INVALID_INDEX if geometry does not exist.
        /// 
        /// \note Access to the BLAS must be externally synchronized.
        uint* GetGeometryDescIndex(IBottomLevelAS*, const(char)* Name);

        /// Returns the geometry index that can be used in a shader binding table.
        
        /// \param [in] Name - Geometry name that is specified in BLASTriangleDesc or BLASBoundingBoxDesc.
        /// \return Geometry index or INVALID_INDEX if geometry does not exist.
        /// 
        /// \note Access to the BLAS must be externally synchronized.
        uint* GetGeometryIndex(IBottomLevelAS*, const(char)* Name);

        /// Returns the geometry count that was used to build AS.
        /// Same as BuildBLASAttribs::TriangleDataCount or BuildBLASAttribs::BoxDataCount.

        /// \return The number of geometries that was used to build AS.
        /// 
        /// \note Access to the BLAS must be externally synchronized.
        uint* GetActualGeometryCount(IBottomLevelAS*);

        /// Returns the scratch buffer info for the current acceleration structure.
        
        /// \return ScratchBufferSizes object, see Diligent::ScratchBufferSizes.
        ScratchBufferSizes* GetScratchBufferSizes(IBottomLevelAS*);

        /// Returns the native acceleration structure handle specific to the underlying graphics API

        /// \return pointer to ID3D12Resource interface, for D3D12 implementation\n
        ///         VkAccelerationStructure handle, for Vulkan implementation
        ulong* GetNativeHandle(IBottomLevelAS*);

        /// Sets the acceleration structure usage state.

        /// \note This method does not perform state transition, but
        ///       resets the internal acceleration structure state to the given value.
        ///       This method should be used after the application finished
        ///       manually managing the acceleration structure state and wants to hand over
        ///       state management back to the engine.
        void* SetState(IBottomLevelAS*, RESOURCE_STATE State);

        /// Returns the internal acceleration structure state
        RESOURCE_STATE* GetState(IBottomLevelAS*);
    }
}

struct IBottomLevelASVtbl { IBottomLevelASMethods BottomLevelAS; }
struct IBottomLevelAS { IBottomLevelASVtbl* pVtbl; }

uint* IBottomLevelAS_GetGeometryDescIndex(IBottomLevelAS* structure, const(char)* name) {
    return BottomLevelAS.pVtbl.BottomLevelAS.GetGeometryDescIndex(structure, name);
}

uint* IBottomLevelAS_GetGeometryIndex(IBottomLevelAS* structure, const(char)* name) {
    return BottomLevelAS.pVtbl.BottomLevelAS.GetGeometryIndex(structure, name);
}

uint* IBottomLevelAS_GetActualGeometryCount(IBottomLevelAS* structure) {
    return structure.pVtbl.BottomLevelAS.GetActualGeometryCount(structure);
}

ScratchBufferSizes* IBottomLevelAS_GetScratchBufferSizes(IBottomLevelAS* structure) {
    return structure.pVtbl.BottomLevelAS.GetScratchBufferSizes(structure);
}

ulong* IBottomLevelAS_GetNativeHandle(IBottomLevelAS* structure) {
    return structure.pVtbl.BottomLevelAS.GetNativeHandle(structure);
}

void* IBottomLevelAS_SetState(IBottomLevelAS* structure, RESOURCE_STATE State) {
    return structure.pVtbl.BottomLevelAS.SetState(structure, state);
}
RESOURCE_STATE* IBottomLevelAS_GetState(IBottomLevelAS* structure) {
    return structure.pVtbl.BottomLevelAS.GetState(structure);
}